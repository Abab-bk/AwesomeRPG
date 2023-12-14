shader_type canvas_item;

uniform float transition_progress : hint_range(0.0, 1.0, 0.01);

void vertex() {
    // 计算中心点
    vec2 center = vec2(0.5, 0.5);

    // 计算当前顶点到中心的距离
    float distance_to_center = abs(VERTEX.x - center.x);

    // 计算缩放因子，使中心点不动，两侧点向两边移动，并在过渡进程中逐渐伸展
    float scale_factor = mix(0.0, 1.0, smoothstep(0.5 - 0.01, 0.5, distance_to_center));

    // 逐渐伸展的效果
    float stretch_factor = mix(1.0, 2.0, transition_progress);

    // 修改顶点位置
    VERTEX.x = mix(center.x + (VERTEX.x - center.x) * scale_factor * stretch_factor, VERTEX.x, transition_progress);
}

void fragment() {
    COLOR.a = transition_progress;
}
