// #!/usr/bin/env cppsh
// cppsh::LIBS -lboost_thread

#include <iostream>
#include <thread>

#include "boost/thread.hpp"
#include "boost/thread/thread_guard.hpp"
#include "boost/thread/exceptions.hpp"
#include "boost/thread/scoped_thread.hpp"

#define LOG( A ) std::cout << A << std::endl;

void work() {
    size_t sum = 0;

    for(int i = 0; i < 1E7; ++i) { sum += 1; }

    LOG("work: " << sum);
}

// helper struct to interrupt a boost::thread within a boost::thread
struct non_interruptable_interrupt_and_join_if_joinable {
    template <class Thread>
    void operator()(Thread& t) {
        if(t.joinable()) {
            t.interrupt();

            boost::this_thread::disable_interruption di;
            t.join();

            // try { t.join(); } catch(boost::thread_interrupted&) {}
        }
    }
};

template<class T>
struct scopeguard {
    T _callable;
    scopeguard( T callable ) : _callable( callable ) {}
    ~scopeguard() { _callable(); }
};

void double_interrupt() {
    boost::thread outer([] {
        boost::scoped_thread<boost::interrupt_and_join_if_joinable> inner([] {
            while(true) {
                boost::this_thread::interruption_point();
                work();
            }
        });
        {
            // boost::thread_guard<boost::interrupt_and_join_if_joinable> guard(inner);
//            scopeguard g([&] {
//                inner.interrupt();
//                inner.join();
//            });
            LOG("Interrupting inner");
            // inner.interrupt();
            // inner.join();
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
