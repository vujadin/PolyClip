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

package com.bayvakoof.polyclip.sweepline;

import flash.geom.Point;
import com.bayvakoof.polyclip.geom.Segment;
	
/**
 * ...
 * @haxeport Krtolica Vujadin
 */

/**
 * A container for SweepEvent data. A SweepEvent represents a location of interest (vertex between two polygon edges)
 * as the sweep line passes through the polygons.
 * @author Mahir Iqbal
 */

class SweepEvent 
{

	public var p:Point;
	public var isLeft:Bool; 		// Is the point the left endpoint of the segment (p, other->p)?
	public var polygonType:Int; 	// PolygonType to which this event belongs to: either PolygonClipper.SUBJECT, or PolygonClipper.CLIPPING
	public var otherSE:SweepEvent; 	// Event associated to the other endpoint of the segment
	
	/* Does the segment (p, other->p) represent an inside-outside transition
	 * in the polygon for a vertical ray from (p.x, -infinite) that crosses the segment? 
	 */
	public var inOut:Bool;
	public var edgeType:Int; 		// The EdgeType. @see EdgeType.as
	
	public var inside:Bool; 		// Only used in "left" events. Is the segment (p, other->p) inside the other polygon?
	
	public function new(p:Point, isLeft:Bool, polyType:Int, otherSweepEvent:SweepEvent = null, edgeType:Int = 0)
	{
		this.p = p;
		this.isLeft = isLeft;
		polygonType = polyType;
		otherSE = otherSweepEvent;
		this.edgeType = edgeType;
	}
	
	public var segment(get, null):Segment;
	private function get_segment():Segment
	{
		return new Segment(p, otherSE.p);
	}
	
	// Checks if this sweep event is below point p.
	public function isBelow(x:Point):Bool
	{
		function signedArea(p0:Point, p1:Point, p2:Point):Float
		{
			return (p0.x - p2.x) * (p1.y - p2.y) - (p1.x - p2.x) * (p0.y - p2.y);
		}
		
		return (isLeft) ? (signedArea(p, otherSE.p, x) > 0) : (signedArea(otherSE.p, p, x) > 0);		
	}
		
	public function isAbove(x:Point):Bool
	{
		return !isBelow(x);
	}
	
}