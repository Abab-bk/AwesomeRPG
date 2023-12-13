shader_type canvas_item;

uniform float health : hint_range(0.0, 1.0) = 1.0; // 玩家血量，范围在0到1之间

void vertex() {
    // 不做任何顶点变换
}

void fragment() {
    // 计算血球的中心坐标
    vec2 center = vec2(0.5, 0.5);

    // 计算当前像素与中心的距离
    float distance = distance(FRAGCOORD.xy / SCREEN_PIXEL_SIZE, center);

    // 计算血球的半径
    float radius = 0.4;

    // 计算血球的边缘模糊效果
    float softness = 0.1;

    // 计算当前像素在血球内的范围
    float inner_range = radius - softness;
    float outer_range = radius + softness;

    // 将范围映射到0到1之间
    float alpha = smoothstep(inner_range, outer_range, distance);

    // 根据玩家血量调整颜色
    vec4 color = vec4(1.0, 0.0, 0.0, alpha * health);

    // 将颜色输出到屏幕
    COLOR = color;
}
