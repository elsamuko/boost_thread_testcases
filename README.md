# Test cases for boost::thread

```js
-----------------------------------------------------------------
With boost::scoped_thread<boost::interrupt_and_join_if_joinable>
Start
Interrupting outer
Interrupting inner
terminate called after throwing an instance of 'boost::thread_interrupted'
./run.sh: line 28: 46156 Aborted                 (core dumped) ./bin/release/double_interrupt
Crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With boost::scoped_thread<boost::non_interruptable_interrupt_and_join_if_joinable>
Start
Interrupting outer
Interrupting inner
End
No crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With boost::thread_guard<boost::interrupt_and_join_if_joinable>
Start
Interrupting outer
Interrupting inner
terminate called after throwing an instance of 'boost::thread_interrupted'
./run.sh: line 28: 46210 Aborted                 (core dumped) ./bin/release/double_interrupt
Crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With boost::thread_guard<boost::non_interruptable_interrupt_and_join_if_joinable>
Start
Interrupting outer
Interrupting inner
End
No crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With ~scope_guard()
Start
Interrupting outer
Interrupting inner
terminate called after throwing an instance of 'boost::thread_interrupted'
./run.sh: line 28: 46264 Aborted                 (core dumped) ./bin/release/double_interrupt
Crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With boost::this_thread::disable_interruption
Start
Interrupting outer
Interrupting inner
End
No crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With catch(boost::thread_interrupted&)
Start
Interrupting outer
Interrupting inner
End
No crash
-----------------------------------------------------------------

-----------------------------------------------------------------
With boost::thread::join()
Start
Interrupting outer
Interrupting inner
End
No crash
-----------------------------------------------------------------
```