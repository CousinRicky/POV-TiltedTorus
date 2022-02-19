/* tiltedtorus.pov version 3.0.1A
 * Persistence of Vision Raytracer scene description file
 * POV-Ray Object Collection demo
 *
 * Demo of tiltedtorus.inc
 *
 * Copyright (C) 2012 - 2022 Richard Callwood III.  Some rights reserved.
 * This file is licensed under the terms of the CC-LGPL
 * a.k.a. the GNU Lesser General Public License version 2.1.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License version 2.1 as published by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Please
 * visit https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html for
 * the text of the GNU Lesser General Public License version 2.1.
 *
 * Vers.  Date         Comments
 * -----  ----         --------
 * 1.0    2012-Jul-21  Created.
 * 2.0    2014-Oct-09  Lathe demo is added.
 * 2.0    2014-Oct-09  Isosurface max_gradient is added for yScale < 1.
 * 2.0a   2014-Nov-07  No change.
 * 3.0    2016-Apr-02  For the lathe, the Sturm argument is used instead of the
 *                     global parameter.
 * 3.0    2016-Apr-02  The lathe example is uv mapped.
 * 3.0.1  2019-Apr-01  The prefix on container identifier is changed from "v_"
 *                     (vector) to "lv_" (location vector).
 * 3.0.1A 2021-Oct-11  The license text is updated.
 *        2022-Feb-19  "lv_" is changed to "pv_" (point vector).
 */
#version 3.5;
#include "screen.inc"
#include "tiltedtorus.inc"

#ifndef (Annotate) #declare Annotate = yes; #end
#ifndef (Tilt) #declare Tilt = -45; #end
#ifndef (Type) #declare Type = 2; #end
#ifndef (yScale) #declare yScale = 2; #end

#ifndef (Test_Sturm) #declare Test_Sturm = no; #end // development testing

#declare RMAJOR = 4;
#declare rMINOR = 1;

global_settings { assumed_gamma 1 }

Set_Camera (vrotate (<0, 0, -4 * (RMAJOR + 2.5)>, <20, 10, 0>), -0.7 * y, 30)

light_source
{ <-1, 2, -3> * 1000, rgb 1
  parallel point_at 0
}
#default { finish { specular 0.25 roughness 0.025 ambient 0.06 diffuse 0.75 } }

#declare pv_Container = TiltedTorus_Container_v (RMAJOR, rMINOR, yScale, Tilt);

difference
{ #switch (Type)
    #case (1)
      isosurface
      { function { TiltedTorus_fn (x, y, z, RMAJOR, rMINOR, yScale, Tilt) }
        contained_by { box { -pv_Container, pv_Container } }
        max_gradient 1 / (rMINOR * min (yScale, 1))
        max_trace 3
      }
      #break
    #case (2)
      object
      { TiltedTorus_Lathed (RMAJOR, rMINOR, yScale, Tilt, Test_Sturm)
        pigment
        { uv_mapping
          function { sin (x * pi) * 0.125 + y }
          color_map
          { [0.15 rgb <0.0, 0.05, 0.35>]
            [0.15 rgb <1.0, 0.75, 0.0>]
            [0.30 rgb <1.0, 0.75, 0.0>]
            [0.30 rgb <0.8, 0.0, 0.06>]
            [0.45 rgb <0.8, 0.0, 0.06>]
            [0.45 rgb <1.0, 0.3, 0.45>]
          }
          translate (0.125 - 0.35) * y
          scale <1/20, 1/4, 1>
        }
      }
      #break
  #end
  box
  { -pv_Container, pv_Container * y
    scale 1.01
  }
  pigment { rgb <1.0, 0.3, 0.45> }
}

//==============================================================================

#if (Annotate)

  #macro Annotation (Text, Font)
    text
    { ttf Font Text 0.001, 0
      scale 0.075
      pigment { rgb 1 }
      finish { ambient 1 diffuse 0 }
    }
  #end

  Screen_Object
  ( Annotation
    ( #switch (Type)
        #case (1) "Isosurface" #break
        #case (2) "Lathe" #break
        #else concat ("Unknown type ", str (Type, 0, -1)) #break
      #end,
      "cyrvetic"
    ),
    <0, 1>, <0.02, 0.02>, yes, 1
  )
  Screen_Object
  ( Annotation (concat ("yScale = ", str(yScale,0,3)), "crystal"),
    <0, 0>, <0.02, 0.006>, yes, 1
  )
  Screen_Object
  ( Annotation (concat ("Tilt = ", str(Tilt,0,3)), "crystal"),
    <1, 0>, <0.02, 0.02>, yes, 1
  )

#end
// end of tiltedtorus.pov
