import QtQuick 2.2
import QtQuick.Controls 1.1

import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0

import Material 0.1

import Material.ListItems 0.1 as ListItem

import com.ics.demo 1.0

ApplicationWindow {
    id: demo
    visible: true
    width: 640
    height: 480
    title: qsTr("Demo")


    theme {
        primaryColor: Palette.colors["grey"]["800"]
        primaryDarkColor: Palette.colors["grey"]["900"]
        accentColor: Palette.colors["red"]["500"]
        tabHighlightColor: "red"
    }

    property var home: [
            "info", "lastProjects"
    ]

    property var menuTitles: [[
            "Общая информация", "Последние проекты"
    ],[
        "Мои задачи", "Мой контроль", "Все задачи"

    ],["Все проекты", "Мои проекты"]]

    property var myPage: [
            "myTasks", "myControls", "allPick"
    ]


    property var projects: [
            "allProjects", "myProjects"
    ]

    property var sections: [ home, myPage, projects ]

    property var sectionTitles: [ "Домашняя страница", "Моя страница", "Проекты" ]

    property string selectedComponent: home[0]

    initialPage: Page {
        id: page

        title: "Управление задачами"
        //Icon:



        tabs: navDrawer.enabled ? [] : sectionTitles

        actionBar.maxActionCount: navDrawer.enabled ? 3 : 2

        actions: [
//            Action {
//                iconName: "action/search"
//                name: "Search"
//                enabled: false
//            },

//            Action {
//                iconName: "image/color_lens"
//                name: "Colors"
//                onTriggered: colorPicker.show()
//            },

            Action {
                iconName: "action/settings"
                name: "Settings"
                hoverAnimation: true
            },

            Action {
                iconName: "alert/warning"
                name: "THIS SHOULD BE HIDDEN!"
                visible: false
            },

            Action {
                iconName: "action/language"
                name: "Language"
                enabled: false
            },

            Action {
                iconName: "action/account_circle"
                name: "Accounts"
            }
        ]

        backAction: navDrawer.action

        NavigationDrawer {
            id: navDrawer

            enabled: page.width < Units.dp(500)

            Flickable {
                anchors.fill: parent

                contentHeight: Math.max(content.implicitHeight, height)

                Column {
                    id: content
                    anchors.fill: parent

                    Repeater {
                        model: sections

                        delegate: Column {
                            width: parent.width

                            ListItem.Subheader {
                                text: sectionTitles[index]

                            }

                            Repeater {
                                model: modelData
                                delegate: ListItem.Standard {
                                    text: modelData

                                    selected: modelData == demo.selectedComponent
                                    onClicked: {
                                        demo.selectedComponent = modelData
                                        navDrawer.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        TabView {
            id: tabView
            anchors.fill: parent
            currentIndex: page.selectedTab
            model: sections

            delegate: Item {
                width: tabView.width
                height: tabView.height
                clip: true

                property string selectedComponent: modelData[0]

                Sidebar {
                    id: sidebar

                    expanded: !navDrawer.enabled

                    Column {
                        width: parent.width

                        Repeater {
                            model: modelData
                            delegate: ListItem.Standard {
                                text: menuTitles[tabView.currentIndex][index] ///!Q
                                selected: modelData == selectedComponent
                                onClicked: selectedComponent = modelData
                            }
                        }
                    }
                }
                Flickable {
                    id: flickable
                    anchors {
                        left: sidebar.right
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    clip: true
                    contentHeight: Math.max(example.implicitHeight + 40, height)
                    Loader {
                        id: example
                        anchors.fill: parent
                        asynchronous: true
                        visible: status == Loader.Ready


                        // selectedComponent will always be valid, as it defaults to the first component
                        source: {
                            if (navDrawer.enabled) {
                                return Qt.resolvedUrl("data/qml/%_data.qml").arg(demo.selectedComponent.replace(" ", ""))
                            } else {
                                return Qt.resolvedUrl("data/qml/%_data.qml").arg(selectedComponent.replace(" ", ""))
                            }
                        }
                    }

                    ProgressCircle {
                        anchors.centerIn: parent
                        visible: example.status == Loader.Loading
                    }
                }
                Scrollbar {
                    flickableItem: flickable
                }
            }
        }
    }

}
