include <../../OpenSCAD_Lib/MakeInclude.scad>
include <../../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

boardX = 20.32;
boardY = 36.37;

standoffCtsOffsetUsbEndX = 2.0;
standoffCtsOffsetUsbEndY = 2.4;

standoffCtsOffsetAntennaEndX = 3.52;
standoffCtsOffsetAntennaEndY = 1.97;

screwHoleDia = 2.4; // m2 clearance

extraXY = 4;
wallXY = 3;
wallZ = 4;

cornerDIaXY = 10;
exteriorCZ = 1;
exteriorZ = 7 + wallZ;

cornerCtrX = boardX/2 + extraXY - cornerDIaXY/2;
cornerCtrY = boardY/2 + extraXY - cornerDIaXY/2;

module itemModule()
{
    difference()
    {
        cornerOffsetY = -12 - cornerDIaXY/2;
        // Exterior:
        hull() cornerXform(offsetY=cornerOffsetY) simpleChamferedCylinderDoubleEnded(d=cornerDIaXY, h=exteriorZ, cz=exteriorCZ);

        // interior:
        translate([0,0,wallZ]) hull() cornerXform(offsetY=cornerOffsetY) cylinder(d=cornerDIaXY-wallXY, h=100);

        // Screw holes:
        standoffsXform(z=-10) cylinder(d=screwHoleDia, h=100);

        // // USB-C cutout:
        // usbCutX = 13;
        // tcu([-usbCutX/2, 0, wallZ], [usbCutX, 100, 100]);

        // Button and USB cut:
        cutX = boardX + 2;
        tcu([-cutX/2, 0, -10], [cutX, 200, 200]);
    }

    hull() cornerXform() simpleChamferedCylinderDoubleEnded(d=cornerDIaXY, h=wallZ, cz=exteriorCZ);
}

module cornerXform(offsetY=0)
{
    doubleX() translate([cornerCtrX, -cornerCtrY, 0]) children();
    doubleX() translate([cornerCtrX, cornerCtrY+offsetY, 0]) children();
}

module standoffsXform(z)
{
    usbHoleCtrX = boardX/2 - standoffCtsOffsetUsbEndX;
    usbHoleCtrY = boardY/2 - standoffCtsOffsetUsbEndY;
    doubleX() translate([usbHoleCtrX, usbHoleCtrY, z]) children();

    antHoleCtrX = boardX/2 - standoffCtsOffsetAntennaEndX;
    antHoleCtrY = -boardY/2 + standoffCtsOffsetAntennaEndY;
    doubleX() translate([antHoleCtrX, antHoleCtrY, z]) children();
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
    displayGhost() boardGhost();
}
else
{
	itemModule();
}

module boardGhost()
{
    standoffZ = 2;

    difference()
    {
        union()
        {
            hull() doubleX() doubleY() translate([boardX/2-1, boardY/2-1, wallZ + standoffZ]) cylinder(d=2, h=4);
            standoffsXform(z=wallZ) cylinder(d=3.5, h=standoffZ);
        }
        
        standoffsXform(z=-10) cylinder(d=2, h=100);
    }
    
}
