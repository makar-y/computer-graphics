# version 120 

/* This is the fragment shader for reading in a scene description, including 
   lighting.  Uniform lights are specified from the main program, and used in 
   the shader.  As well as the material parameters of the object.  */

// Mine is an old machine.  For version 130 or higher, do 
// in vec4 color;  
// in vec3 mynormal; 
// in vec4 myvertex;
// That is certainly more modern

varying vec4 color;
varying vec3 mynormal; 
varying vec4 myvertex; 

const int numLights = 10; 
uniform bool enablelighting; // are we lighting at all (global).
uniform vec4 lightposn[numLights]; // positions of lights 
uniform vec4 lightcolor[numLights]; // colors of lights
uniform int numused;               // number of lights used

// Now, set the material parameters.  These could be varying and/or bound to 
// a buffer.  But for now, I'll just make them uniform.  
// I use ambient, diffuse, specular, shininess as in OpenGL.  
// But, the ambient is just additive and doesn't multiply the lights.  

uniform vec4 ambient; 
uniform vec4 diffuse; 
uniform vec4 specular; 
uniform vec4 emission; 
uniform float shininess; 


void main (void) 
{       
  if (enablelighting) {

    vec4 finalcolor; 

    // YOUR CODE FOR HW 2 HERE
    // A key part is implementation of the fragment shader

    vec4 sumLights = vec4(0);
    vec4 _myPos = gl_ModelViewMatrix * myvertex;
    vec3 myPos = _myPos.xyz/_myPos.w;
    const vec3 eyePos = vec3(0);
    vec3 eyeDir = normalize(eyePos - myPos);
    vec3 _normal = (gl_ModelViewMatrixInverseTranspose*vec4(mynormal,0.0)).xyz ; 
    vec3 normal = normalize(_normal);
    
    for (int i = 0; i < numused; i++) {
      vec3 lightDir;
      if (lightposn[i].w == 0) {
	lightDir = normalize(lightposn[i].xyz);
      } else {
	vec3 lightPos = lightposn[i].xyz/lightposn[i].w;
	lightDir = normalize(lightPos - myPos);
      }
      vec3 halfAng = normalize(lightDir + eyeDir);

      sumLights += lightcolor[i] * (diffuse * max(dot(normal, lightDir), 0.0) + specular * pow( max(dot(normal, halfAng), 0.0), shininess));
    }

    finalcolor = ambient + emission + sumLights; 

    gl_FragColor = finalcolor; 
  } else {
    gl_FragColor = color; 
  }
}
