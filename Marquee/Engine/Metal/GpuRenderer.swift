//
//  GpuRenderer.swift
//  Ledify
//
//  Created by Mark Wong on 23/1/2023.
//

import MetalKit

class GPUEngine {
    
    public static var device: MTLDevice!
    
    public static var commandQueue: MTLCommandQueue!
    
    public static var functionLibrary: ShaderLibrary!
    
    public static var commandBuffer: MTLCommandBuffer!
    
    public static var encoder: MTLComputeCommandEncoder!
    
    public static func ignite(device: MTLDevice) {
        self.device = device
        self.functionLibrary = ShaderLibrary(device: device)
        self.commandQueue = device.makeCommandQueue()
        self.commandBuffer = self.commandQueue.makeCommandBuffer()!
        self.encoder = self.commandBuffer.makeComputeCommandEncoder()!
    }
}

class ShaderLibrary: NSObject {
    
    public var defaultLibrary: MTLLibrary!
    
    init(device: MTLDevice) {
        self.defaultLibrary = device.makeDefaultLibrary()
    }
    
    func createComputeFunction() -> Shader {
        return BasicComputeFunction(name: "ShiftLeft", functionName: "shiftLeft", library: self.defaultLibrary)
    }
    
}

protocol Shader {
    var name: String { get }
    var functionName: String { get }
    var function: MTLFunction { get }
}

public struct BasicComputeFunction: Shader {
    var name: String
    
    var functionName: String
    
    var library: MTLLibrary
    
    var function: MTLFunction {
        let function = library.makeFunction(name: functionName)
        function?.label = name
        return function!
    }

}

class RenderPipelineState: NSObject {
    
}

class GpuRenderer: NSObject {
    
    override init() {
        super.init()
    }
    
    func setup(array: [[Int]]) {
        let startTime = CFAbsoluteTimeGetCurrent()
        // Create a Metal device
        GPUEngine.ignite(device: MTLCreateSystemDefaultDevice()!)
        
        let device = GPUEngine.device!

        // Create a command queue
        let commandQueue = GPUEngine.commandQueue!
        
    //    let array = [[1, 2, 3], [4, 5, 6], [3, 2, 1]]
    //    var array: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: count), count: count)
        let width = array[0].count
        
        let height = array.count
        let size = MemoryLayout<Int>.size * width * height
        
        print("width \(width)")
        
        var simdArray = [vector_int2]()
        for i in 0..<height {
            for j in 0..<width {
                simdArray.append(vector_int2(Int32(array[i][j]),0))
            }
        }

        let shader = GPUEngine.functionLibrary.createComputeFunction()

        var additionComputePipelineState: MTLComputePipelineState!
        do {
            additionComputePipelineState = try device.makeComputePipelineState(function: shader.function)
        } catch {
          print(error)
        }
        //test
        let maxThreadsPerThreadgroup = additionComputePipelineState.maxTotalThreadsPerThreadgroup
        let threadGroupCount = MTLSize(width: width, height: height, depth: 1)
        let threadGroups = MTLSize(width: maxThreadsPerThreadgroup, height: 1, depth: 1)
        
        let buffer = device.makeBuffer(bytes: simdArray, length: size, options: [])!

        let commandBuffer = GPUEngine.commandBuffer!
        let encoder = GPUEngine.encoder!
        encoder.setComputePipelineState(additionComputePipelineState)
        encoder.setBuffer(buffer, offset: 0, index: 0)
        encoder.setBytes([width], length: MemoryLayout<Int>.stride, index: 1)
        encoder.dispatchThreadgroups(threadGroupCount, threadsPerThreadgroup: threadGroups)
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        // Print out the dlapsed time
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed \(String(format: "%.05f", timeElapsed)) seconds")
        print()
        
        let result = buffer.contents().bindMemory(to: vector_int2.self, capacity: MemoryLayout<Int>.size*width*height)
        for i in 0..<height {
            for j in 0..<width {
                print("\(result[i*width+j].x) ", terminator: "")
            }
            print()
        }
    }
}
