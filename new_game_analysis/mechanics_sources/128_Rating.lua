-- Decompiled with Potassium's decompiler.

local u1 = {
    MU = 25,
    SIGMA = 8.333333333333334,
    BETA = 4.166666666666667,
    TAU = 0.08333333333333333
};

function u1.New() -- Line: 19
    -- upvalues: u1 (copy)
    return {
        Mu = u1.MU,
        Sigma = u1.SIGMA
    };
end;

local function updateSide(p2: table, p3: number, p4: number, p5: number) -- Line: 23
    local v6 = {};

    for i, v in p2 do
        local v7 = v.Sigma * v.Sigma / p3;
        local v8 = {
            Mu = v.Mu + v7 * p4
        };
        local Sigma = v.Sigma;
        local math_max_ret = math.max(1 - v7 * p5, 0.0001);
        v8.Sigma = Sigma * math.sqrt(math_max_ret);
        v6[i] = v8;
    end;

    return v6;
end;

function u1.Update(p9: table, p10: table, p11: number) -- Line: 41
    -- upvalues: u1 (copy), updateSide (copy)
    local u12 = u1.TAU * u1.TAU;

    local function withDynamics(p13: table) -- Line: 43
        -- upvalues: u12 (copy)
        local v14 = {};

        for i, v in p13 do
            v14[i] = {
                Mu = v.Mu,
                Sigma = math.sqrt(v.Sigma * v.Sigma + u12)
            };
        end;

        return v14;
    end;

    local v15 = withDynamics(p9);
    local v16 = withDynamics(p10);

    local function sums(p17: table) -- Line: 53
        local v18 = 0;
        local v19 = 0;

        for _, v in p17 do
            v18 = v18 + v.Mu;
            v19 = v19 + v.Sigma * v.Sigma;
        end;

        return v18, v19;
    end;

    local v20 = 0;
    local v21 = 0;

    for _, v in v15 do
        v20 = v20 + v.Mu;
        v21 = v21 + v.Sigma * v.Sigma;
    end;

    local v22 = 0;
    local v23 = 0;

    for _, v in v16 do
        v22 = v22 + v.Mu;
        v23 = v23 + v.Sigma * v.Sigma;
    end;

    local math_sqrt_ret = math.sqrt(v21 + v23 + 2 * u1.BETA * u1.BETA);
    local math_exp_ret = math.exp(v20 / math_sqrt_ret);
    local v24 = math_exp_ret / (math_exp_ret + math.exp(v22 / math_sqrt_ret));
    local v25 = 1 - v24;
    local v26 = v21 / (math_sqrt_ret * math_sqrt_ret) * (math.sqrt(v21) / math_sqrt_ret) * v24 * (1 - v24);
    local v27 = v23 / (math_sqrt_ret * math_sqrt_ret) * (math.sqrt(v23) / math_sqrt_ret) * v25 * (1 - v25);

    return updateSide(v15, v21, v21 / math_sqrt_ret * (p11 - v24), v26), updateSide(v16, v23, v23 / math_sqrt_ret * (1 - p11 - v25), v27), v24;
end;

return u1;