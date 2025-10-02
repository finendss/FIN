-- Lua卡密验证系统 - GitHub版本
local LicenseSystem = {
    version = "1.0",
    licenses = {},
    config = {
        data_file = "license_data.txt",
        log_file = "system_log.txt"
    }
}

-- 生成随机卡密
function LicenseSystem:generateKey()
    local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789_-"
    local key = ""
    for i = 1, 15 do
        local rand = math.random(1, #chars)
        key = key .. chars:sub(rand, rand)
    end
    return key
end

-- 创建卡密
function LicenseSystem:createLicense(license_type, duration)
    local key = self:generateKey()
    local license = {
        key = key,
        type = license_type,
        duration = duration or 1,
        status = "active",
        created_at = os.time(),
        used_by = nil
    }
    
    -- 设置过期时间
    if license_type == "hour" then
        license.expires_at = os.time() + duration * 3600
    elseif license_type == "day" then
        license.expires_at = os.time() + duration * 24 * 3600
    elseif license_type == "week" then
        license.expires_at = os.time() + duration * 7 * 24 * 3600
    elseif license_type == "month" then
        license.expires_at = os.time() + duration * 30 * 24 * 3600
    elseif license_type == "permanent" then
        license.expires_at = nil
    end
    
    self.licenses[key] = license
    return key
end

-- 验证卡密
function LicenseSystem:validateKey(key, user_id)
    if #key ~= 15 then return false, "无效卡密格式" end
    
    local license = self.licenses[key]
    if not license then return false, "卡密不存在" end
    if license.status == "disabled" then return false, "卡密已停用" end
    if license.used_by and license.used_by ~= user_id then 
        return false, "卡密已被他人使用" 
    end
    
    -- 首次使用
    if not license.used_by then
        license.used_by = user_id
        license.status = "used"
    end
    
    return true, "验证成功"
end

-- 管理功能
function LicenseSystem:listLicenses()
    print("=== 卡密列表 ===")
    for key, license in pairs(self.licenses) do
        print(string.format("%s - %s - %s", key, license.type, license.status))
    end
end

function LicenseSystem:disableLicense(key)
    if self.licenses[key] then
        self.licenses[key].status = "disabled"
        return true
    end
    return false
end

-- 演示功能
function LicenseSystem:demo()
    print("=== Lua卡密系统演示 ===")
    
    -- 创建示例卡密
    local key1 = self:createLicense("day", 1)
    local key2 = self:createLicense("week", 1)
    local key3 = self:createLicense("permanent")
    
    print("创建的卡密:")
    print("- " .. key1 .. " (天卡)")
    print("- " .. key2 .. " (周卡)") 
    print("- " .. key3 .. " (永久卡)")
    
    -- 演示验证
    print("\n=== 验证演示 ===")
    local success, msg = self:validateKey(key1, "user123")
    print("验证结果: " .. msg)
    
    -- 显示所有卡密
    self:listLicenses()
end

-- 运行演示
math.randomseed(os.time())
LicenseSystem:demo()
