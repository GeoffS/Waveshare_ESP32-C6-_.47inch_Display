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

extraXY = 3;
wallXY = 3;
wallZ = 3;

cornerDIaXY = 8;
exteriorCZ = 1;
exteriorZ = 10;

cornerCtrX = boardX/2 + extraXY;
cornerCtrY = boardY/2 + extraXY;

module itemModule()
{
    difference()
    {
	// Exterior:
    hull() doubleX() doubleY() translate([cornerCtrX, cornerCtrY, 0]) 
        simpleChamferedCylinderDoubleEnded(d=cornerDIaXY, h=exteriorZ, cz=exteriorCZ);

    // interior:
    hull() doubleX() doubleY() translate([cornerCtrX, cornerCtrY, wallZ]) 
        cylinder(d=cornerDIaXY-wallXY, h=100);

    // Screw holes:
    usbHoleCtrX = boardX/2 - standoffCtsOffsetUsbEndX;
    usbHoleCtrY = boardY/2 - standoffCtsOffsetUsbEndY;
    doubleX() translate([usbHoleCtrX, usbHoleCtrY, -10]) cylinder(d=screwHoleDia, h=100);

    antHoleCtrX = boardX/2 - standoffCtsOffsetAntennaEndX;
    antHoleCtrY = -boardY/2 + standoffCtsOffsetAntennaEndY;
    doubleX() translate([antHoleCtrX, antHoleCtrY, -10]) cylinder(d=screwHoleDia, h=100);
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
