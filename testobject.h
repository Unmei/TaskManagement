#ifndef TESTOBJECT_H
#define TESTOBJECT_H

#include <QObject>

class TestObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged)
public:
    explicit TestObject(QObject *parent = 0);
    QString filename();
     void setFilename(const QString &f);
private:
     QString _filename;
signals:
    void filenameChanged();
public slots:
    void generateKey();

};

#endif // TESTOBJECT_H
