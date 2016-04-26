git clone https://github.com/zealdocs/zeal.git
cd zeal/

brew install qt5 libarchive

CFLAGS="-I/usr/local/opt/qt5/include -I/usr/local/opt/libarchive/include"
CXXFLAGS+="-I/usr/local/opt/qt5/include -I/usr/local/opt/libarchive/include"
LDFLAGS="-L/usr/local/opt/qt5/lib -L/usr/local/opt/libarchive/lib -larchive"
LARCHIVE="/usr/local/opt/libarchive/lib"
export CFLAGS CXXFLAGS LDFLAGS LARCHIVE

ls /usr/local/opt/libarchive/include/archive.h
ls /usr/local/opt/libarchive/include/archive_entry.h
echo '#include </usr/local/opt/libarchive/include/archive.h>
#include </usr/local/opt/libarchive/include/archive_entry.h>
'
nano src/core/extractor.cpp

echo 'QMAKE_CFLAGS += $$(CFLAGS)
QMAKE_CXXFLAGS += $$(CXXFLAGS)
QMAKE_LFLAGS += $$(LDFLAGS)
macx:INCLUDEPATH += $$(LARCHIVE)
macx:DEPENDPATH += $$(LARCHIVE)
' >> src/src.pro

/usr/local/opt/qt5/bin/qmake
make
