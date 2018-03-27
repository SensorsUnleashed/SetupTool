import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQml.Models 2.2
import QtQuick.Layouts 1.3

ListView{
    id: lw;
    anchors.fill: parent;

    signal addNew;
    signal select(var data);

    //property var selectedpair;

    model: pairlist;

    function refresh(){
        activeSensor.getpairingslist();
    }

    highlight: Rectangle {
        color: "lightgrey";
    }
    highlightFollowsCurrentItem: true;
    focus: true

    delegate:Item{
        width: parent.width;
        height: item.height;
        Column{
            id: item;
            Text {
                text: sensorname;
                font.pointSize: 12;
                color: selected == 1 ? "red" : "black";
            }
            Text {
                text: nodename + " (" + nodeip + ")";
                font.pointSize: 8;
                font.italic: true;
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selected = selected == 1 ? 0 : 1;
                lw.currentIndex = index;
                lw.footerItem.children[1].enabled = hasselections;   //The remove button
            }
            onDoubleClicked: {
                var pairdata = {};
                pairdata['addr'] = nodeip;
                pairdata['url'] = sensorname;
                pairdata['triggers'] = eventSetup;
                select(pairdata);
            }
        }
    }

    footerPositioning: ListView.OverlayFooter;
    footer: RowLayout{
        width:  lw.width
        spacing: 5;
        SUButton{
            text: "ADD";
            Layout.fillWidth: true;
            onClicked: {
                addNew();
            }
        }
        SUButton{
            id: rmbut;
            text: "REMOVE";
            Layout.fillWidth: true;
            enabled: pairlist.rowCount() > 0 ? true : false;
            onClicked: {
                pairlist.removePairings();
            }
        }
        SUButton{
            text: "CLEAR";
            Layout.fillWidth: true;
            onClicked: {
                activeSensor.clearpairingslist();
            }
        }
    }

    onVisibleChanged: {
        if(visible){
            refreshbutton.command = refresh;
        }
    }
}
