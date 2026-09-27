-- Decompiled with Potassium's decompiler.

local v1 = {
    WINDUP = 0.5,
    DURATION = 15,
    RUN_SPEED_FACTOR = 0.65,
    STAMINA_TOTAL = 0.3
};
v1.STAMINA_DRAIN = v1.STAMINA_TOTAL / v1.DURATION;
v1.STAMINA_FLOOR = 0;
v1.BUFF_VALUE = "Breathing Boost";
v1.MOVE_THRESHOLD = 0.1;

return v1;