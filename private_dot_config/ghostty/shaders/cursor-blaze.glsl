float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

// Distance-based intensity scaling function
float getTrailIntensity(float lineLength) {
    // Define thresholds for small vs large movements
    const float MIN_DISTANCE = 0.02;  // Very small movements (1-2 chars)
    const float MAX_DISTANCE = 0.08;  // Larger movements (full effect)

    // Scale the intensity based on distance
    float intensityScale = smoothstep(MIN_DISTANCE, MAX_DISTANCE, lineLength);

    // Minimum intensity for small movements (reduce blaze)
    const float MIN_INTENSITY = 0.2;  // 20% of full effect for small moves

    return mix(MIN_INTENSITY, 1.0, intensityScale);
}

// const vec4 TRAIL_COLOR = vec4(1.0, 0.6, 0.4, 1.0); // Catppuccin Frappe Peach
const vec4 TRAIL_COLOR = vec4(0.3, 0.5, 0.8, 1.0); // Catppuccin Frappe Blue
const vec4 TRAIL_COLOR_ACCENT = vec4(1.0, 1.0, 1.0, 1.0);
const float DURATION = 0.2; //IN SECONDS

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    // Normalization for cursor position and size;
    // cursor xy has the postion in a space of -1 to 1;
    // zw has the width and height
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);
    float lineLength = distance(centerCC, centerCP);

    // Get distance-based trail intensity
    float trailIntensity = getTrailIntensity(lineLength);

    // Apply the trail effect with distance-based scaling
    vec4 trail = mix(TRAIL_COLOR_ACCENT, fragColor, 1. - smoothstep(0., sdfCurrentCursor + .005, 0.004) * trailIntensity);
    trail = mix(TRAIL_COLOR, trail, 1. - smoothstep(0., sdfCurrentCursor + .002, 0.004) * trailIntensity);
    fragColor = mix(trail, fragColor, 1. - smoothstep(0., sdfCurrentCursor, easedProgress * lineLength * trailIntensity));
}
