#version 410 core
layout (location = 0) in vec3 position; // The position variable has attribute position 0
layout (location = 1) in vec3 color;	// The color variable has attribute position 1
uniform float offset;  
out vec3 ourColor; // Output a color to the fragment shader
out vec4 pos;

void main()
{
    gl_Position = vec4(position.x, -position.y, position.z, 1.0);
    ourColor = vec3(position.x, -position.y, position.z); // Set ourColor to the input color we got from the vertex data
    
}
       
