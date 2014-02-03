/* Copyright (c) 2011 Mahir Iqbal
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bayvakoof.polyclip.geom;

import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @haxeport Krtolica Vujadin
 */

/**
 * A complex polygon is represented by many contours (i.e. simple polygons).
 * @see Contour.as
 * @author Mahir Iqbal
 */

class Polygon 
{

	public var contours:Array<Contour>;		
	public var bounds:Rectangle;
	
	public function new()
	{
		contours = new Array<Contour>();
		bounds = null;
	}
	
	public function numVertices():Int
	{
		var verticesCount:Int = 0;
		for(c in contours) {
			verticesCount += c.points.length;
		}
		
		return verticesCount;
	}
	
	public function getVertices():Array<Point> {
		var allVertices:Array<Point> = new Array();
		for(c in contours) {
			for (p in c.points) {
				allVertices.push(p);
			}
		}
		return allVertices;
	}
	
	public var boundingBox(get, null):Rectangle;
	private function get_boundingBox():Rectangle
	{
		if (bounds != null)
			return bounds;
		
		var bb:Rectangle = null;
		for(c in contours)
		{
			var cBB:Rectangle = c.boundingBox;
			if (bb == null)
				bb = cBB;
			else
				bb = bb.union(cBB);
		}
		
		bounds = bb;
		return bounds;
	}
	
	public function addContour(c:Contour):Void
	{
		contours.push(c);
	}
	
	public function clone():Polygon
	{
		var poly:Polygon = new Polygon();
		for(cont in this.contours)
		{
			var c:Contour = new Contour();
			for(p in cont.points)
				c.add(p.clone());
			
			poly.addContour(c);
		}
		return poly;
	}
	
}