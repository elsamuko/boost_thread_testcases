// #!/usr/bin/env cppsh
// cppsh::LIBS -lboost_thread

#include <iostream>
#include <thread>
#include <fstream>

#include "boost/thread.hpp"
#include "boost/thread/thread_guard.hpp"
#include "boost/thread/exceptions.hpp"
#include "boost/thread/scoped_thread.hpp"
#include "boost/thread/thread_functors.hpp"

#define LOG( A ) std::cout << A << std::endl;

void work() {
    size_t sum = 0;

    for(int i = 0; i < 1E7; ++i) { sum += 1; }

    std::ofstream( "result.txt" ) << sum;
}

// helper struct to interrupt a boost::thread within a boost::thread
struct non_interruptable_interrupt_and_join_if_joinable {
    template <class Thread>
    void operator()(Thread& t) {
        if(t.joinable()) {
            t.interrupt();

#if INTERRUPT_TYPE == INTERRUPT_TYPE_NON_INTERRUPT
            boost::this_thread::disable_interruption di;
            t.join();
#else
            try { t.join(); } catch(boost::thread_interrupted&) {}
#endif
        }
    }
};

template<class T>
struct scope_guard {
    T _callable;
    scope_guard( T callable ) : _callable( callable ) {}
    ~scope_guard() { _callable(); }
};

void double_interrupt() {
    boost::thread outer([] {
#if INTERRUPT_TYPE == INTERRUPT_TYPE_SCOPED_THREAD
        boost::scoped_thread<boost::interrupt_and_join_if_joinable> inner([] {
#elif INTERRUPT_TYPE == INTERRUPT_TYPE_SCOPED_THREAD_NI
        boost::scoped_thread<boost::non_interruptable_interrupt_and_join_if_joinable> inner([] {
#else
        boost::thread inner([] {
#endif
            while(true) {
                boost::this_thread::interruption_point();
                work();
            }
        });
        {
#if INTERRUPT_TYPE == INTERRUPT_TYPE_NON_INTERRUPT || INTERRUPT_TYPE == INTERRUPT_TYPE_CATCH
            boost::thread_guard<non_interruptable_interrupt_and_join_if_joinable> guard(inner);
#elif INTERRUPT_TYPE == INTERRUPT_TYPE_THREAD_GUARD
            boost::thread_guard<boost::interrupt_and_join_if_joinable> guard(inner);
#elif INTERRUPT_TYPE == INTERRUPT_TYPE_THREAD_GUARD_NI
            boost::thread_guard<boost::non_interruptable_interrupt_and_join_if_joinable> guard(inner);
#elif INTERRUPT_TYPE == INTERRUPT_TYPE_SCOPE_GUARD
            scope_guard g([&] {
                inner.interrupt();
                inner.join();
            });
#elif INTERRUPT_TYPE == INTERRUPT_TYPE_MANUAL
            LOG("Interrupting inner");
            inner.interrupt();
            inner.join();
#endif
            LOG("Interrupting inner");
        }
    });
    LOG("Interrupting outer");
    outer.interrupt();
    outer.join();
}

int main() {
    LOG("Start");
    double_interrupt();
    LOG("End");
}
