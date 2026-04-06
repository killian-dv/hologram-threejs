void main() {
  vec4 modelPosition = modelMatrix * vec4(position, 1.0);
  
  // final position
  gl_Position = projectionMatrix * viewMatrix * modelPosition;
}