/*
 * Originally from http://github.com/aleclarson/swift-timer
 * but author has deleted the repo.
 * ¯\_(ツ)_/¯
 */

import Foundation

// Retains non-repeating timers
private var timers = [String:Timer]()

class Timer
{
    let name: String?
    let delay: Double
    let handler: Void -> Void
	let repeats: Bool
	
	private var nsTimer: NSTimer?
	
    convenience init(_ delay: Double, _ handler: Void -> Void)
	{
        self.init(NSUUID().UUIDString, delay, handler)
    }
    
    init(_ name: String, _ delay: Double, _ handler: Void -> Void)
	{
        timers[name]?.kill()
        
        self.name = name
        self.delay = delay
        self.handler = handler
		self.repeats = false
        
        timers[name] = self
	}
	
	private init(`repeat` delay: Double, _ handler: Void -> Void)
	{
		self.name = nil
		self.delay = delay
		self.handler = handler
		self.repeats = true
	}
	
    class func `repeat`(before delay: Double, _ handler: Void -> Void) -> Timer
	{
        handler()
        return Timer(repeat: delay, handler)
    }
    
    class func `repeat`(after delay: Double, _ handler: Void -> Void) -> Timer
	{
        return Timer(repeat: delay, handler)
    }
    
    class func named(name: String) -> Timer?
	{
        return timers[name]
    }
    
    func start()
	{
        if nsTimer != nil { return }
        nsTimer = NSTimer(timeInterval: delay, target: self, selector: #selector(Timer.execute), userInfo: nil, repeats: repeats)
        NSRunLoop.currentRunLoop().addTimer(nsTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func stop()
	{
        if nsTimer == nil { return }
        nsTimer!.invalidate()
        nsTimer = nil
    }
    
    func fire()
	{
        handler()
        kill()
    }
    
    func kill()
	{
        stop()
        if name != nil { timers[name!] = nil }
    }
    
    @objc private func execute ()
	{
        handler()
        if !repeats { kill() }
    }
}
