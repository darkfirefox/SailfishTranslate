import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "Database.js" as JS

Page{
    allowedOrientations: Orientation.All

    SilicaListView{
        id: listView
        anchors.fill: parent
        model: MyModel{}
        header: PageHeader {
            title: qsTr("History")
        }
        delegate: ListItem{
            id: listItem
            menu: contextMenu
            ListView.onRemove: animateRemoval(listItem)
            function remove() {
                remorseAction("Deleting", function() { listView.model.remove(index) })
                JS.dbDeleteRow(id)
            }
            Row{
                Column{
                    Text{
                        text: fromL
                        color: "white"
                    }
                    Text{
                        text: toL
                        color: "red"
                    }
                }
                Column{
                    Text{
                        text: fromT
                        color: "white"
                    }
                    Text{
                        text: toT
                        color: "red"
                    }
                }}
            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: "Remove"
                        onClicked: remove()
                    }
                }
            }
        }
    }
}

