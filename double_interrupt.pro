CONFIG -= qt

SOURCES += double_interrupt.cpp

SOURCES += thread/src/pthread/once_atomic.cpp \
           thread/src/pthread/thread.cpp \
           thread/src/pthread/once.cpp

INCLUDEPATH += thread/include

QMAKE_LFLAGS += -pthread
