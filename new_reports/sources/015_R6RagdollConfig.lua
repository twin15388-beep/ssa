-- Decompiled with Potassium's decompiler.

return {
    RagdollOnDeath = true,
    DeathCorpseLifetime = 10,
    CollisionGroupName = "R6Ragdoll",
    JointLimits = {
        Neck = {
            UpperAngle = 35,
            TwistLowerAngle = -45,
            TwistUpperAngle = 45
        },
        ["Left Shoulder"] = {
            UpperAngle = 90,
            TwistLowerAngle = -80,
            TwistUpperAngle = 80
        },
        ["Right Shoulder"] = {
            UpperAngle = 90,
            TwistLowerAngle = -80,
            TwistUpperAngle = 80
        },
        ["Left Hip"] = {
            UpperAngle = 65,
            TwistLowerAngle = -45,
            TwistUpperAngle = 45
        },
        ["Right Hip"] = {
            UpperAngle = 65,
            TwistLowerAngle = -45,
            TwistUpperAngle = 45
        },
        RootJoint = {
            UpperAngle = 30,
            TwistLowerAngle = -30,
            TwistUpperAngle = 30
        }
    }
};