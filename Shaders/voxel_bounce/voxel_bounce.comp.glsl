#version 450

#include "compiled.glsl"
#include "std/conetrace.glsl"
#include "std/gbuffer.glsl"

// layout (local_size_x = 4, local_size_y = 4, local_size_z = 4) in;
layout (local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

uniform layout(binding = 0, r32ui) readonly uimage3D voxelsNor;
uniform layout(binding = 1) sampler3D voxelsFrom;
uniform layout(binding = 2, rgba8) writeonly image3D voxelsTo;

void main() {

    vec4 col = texelFetch(voxelsFrom, ivec3(gl_GlobalInvocationID.xyz), 0);
    if (col.a == 0.0) {
    	imageStore(voxelsTo, ivec3(gl_GlobalInvocationID.xyz), col);
    	return;
    }

    const vec3 hres = voxelgiResolution / 2;
    vec3 wposition = ((gl_GlobalInvocationID.xyz - hres) / hres) * voxelgiHalfExtents;

    uint unor = imageLoad(voxelsNor, ivec3(gl_GlobalInvocationID.xyz)).r;
    vec3 wnormal = decNor(unor);

    col.rgb += traceDiffuse(((gl_GlobalInvocationID.xyz - hres) / hres), wnormal, voxelsFrom).rgb * voxelgiDiff;

    imageStore(voxelsTo, ivec3(gl_GlobalInvocationID.xyz), col);
}
