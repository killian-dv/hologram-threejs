varying vec3 vPosition;

uniform float uTime;

void main() {
  // stripes
  float stripes = mod((vPosition.y - uTime * 0.02) * 20.0, 1.0);
  stripes = pow(stripes, 3.0);
  gl_FragColor = vec4(vec3(1.0), stripes);
  #include <tonemapping_fragment>
  #include <colorspace_fragment>
}