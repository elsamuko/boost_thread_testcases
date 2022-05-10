CONFIG -= qt

MAIN_DIR=.

SOURCES += double_interrupt.cpp

SOURCES += thread/src/pthread/once_atomic.cpp \
           thread/src/pthread/thread.cpp \
           thread/src/pthread/once.cpp

HEADERS += non_interruptable.hpp

INCLUDEPATH += . \
               thread/include

QMAKE_LFLAGS += -pthread

# set debug/release info
CONFIG(debug, debug|release) {
    COMPILE_MODE=debug
}

CONFIG(release, debug|release) {
    COMPILE_MODE=release
}

DEFINES += INTERRUPT_TYPE_SCOPED_THREAD=1
DEFINES += INTERRUPT_TYPE_SCOPED_THREAD_NI=2
DEFINES += INTERRUPT_TYPE_THREAD_GUARD=3
DEFINES += INTERRUPT_TYPE_THREAD_GUARD_NI=4
DEFINES += INTERRUPT_TYPE_SCOPE_GUARD=5
DEFINES += INTERRUPT_TYPE_NON_INTERRUPT=6
DEFINES += INTERRUPT_TYPE_CATCH=7
DEFINES += INTERRUPT_TYPE_MANUAL=8

with_scoped_thread    : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_SCOPED_THREAD
with_scoped_thread_ni : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_SCOPED_THREAD_NI
with_thread_guard     : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_THREAD_GUARD
with_thread_guard_ni  : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_THREAD_GUARD_NI
with_scope_guard      : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_SCOPE_GUARD
with_non_interrupt    : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_NON_INTERRUPT
with_catch            : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_CATCH
with_manual           : DEFINES += INTERRUPT_TYPE=INTERRUPT_TYPE_MANUAL

CONFIG += c++1z

macx:       PLATFORM=mac
win32:      PLATFORM=win
unix:!macx: PLATFORM=linux
unix:!macx: CONFIG += linux

OBJECTS_DIR = $${MAIN_DIR}/tmp/$${TARGET}/$${COMPILE_MODE}/objects
MOC_DIR = $${MAIN_DIR}/tmp/$${TARGET}/$${COMPILE_MODE}/moc
UI_DIR = $${MAIN_DIR}/tmp/$${TARGET}/$${COMPILE_MODE}/uic
RCC_DIR = $${MAIN_DIR}/tmp/$${TARGET}/$${COMPILE_MODE}/rcc
DESTDIR = $${MAIN_DIR}/bin/$${COMPILE_MODE}
