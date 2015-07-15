#include "testobject.h"

TestObject::TestObject(QObject *parent) :
    QObject(parent)
{
}

QString TestObject::filename()
{
    return _filename;
}

void TestObject::setFilename(const QString &f)
{
    if (f != _filename) {
        _filename = f;
        emit filenameChanged();
    }
}

void TestObject::generateKey()
{
    setFilename(QString::number(qrand()));
}
