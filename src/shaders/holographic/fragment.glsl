varying vec3 vPosition;
varying vec3 vNormal;

uniform float uTime;

void main() {
  // normal 
  vec3 normal = normalize(vNormal);

  // stripes
  float stripes = mod((vPosition.y - uTime * 0.02) * 20.0, 1.0);
  stripes = pow(stripes, 3.0);

  // fresnel
  vec3 viewDirection = normalize(vPosition - cameraPosition);
  float fresnel = dot(viewDirection, normal) + 1.0;
  fresnel = pow(fresnel, 2.0);

  // holographic
  float holographic = fresnel * stripes;
  holographic += fresnel * 1.25;

  gl_FragColor = vec4(vec3(1.0), holographic);
  #include <tonemapping_fragment>
  #include <colorspace_fragment>
}