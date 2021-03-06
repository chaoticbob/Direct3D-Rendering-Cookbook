// Copyright (c) 2013 Justin Stenning
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//-------------------------------
// IMPORTANT: When creating a new shader file use "Save As...", "Save with encoding", 
// and then select "Western European (Windows) - Codepage 1252" as the 
// D3DCompiler cannot handle the default encoding of "UTF-8 with signature"
//-------------------------------

// Globals for texture sampling
Texture2D Texture0 : register(t0);
TextureCube Reflection : register(t1);
SamplerState Sampler : register(s0);

#include "Common.hlsl"

// A simple Pixel Shader that simply passes through the interpolated color
float4 PSMain(PixelShaderInput pixel) : SV_Target
{
    // Texture sample here (use white if no texture)
    float4 result = (float4)1.0;
    if (HasTexture)
        result = Texture0.Sample(Sampler, pixel.TextureUV);

    // Calculate reflection (if any)
    if (IsReflective) {
        float3 toEye = normalize(CameraPosition - pixel.WorldPosition);
        pixel.WorldNormal = normalize(pixel.WorldNormal);

        float3 reflection = reflect(-toEye, pixel.WorldNormal);
        result += Reflection.Sample(Sampler, reflection);
    }

    // Return result
    return result;
}