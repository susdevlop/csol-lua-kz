Common.UseWeaponInven(true)
WeaponList = {}
a = 0
while a<1000 do 
    a=a+1
    table.insert(WeaponList,a)
end
for key,value in pairs(WeaponList) do
    function weaponindex()
        wp = Common.GetWeaponOption(value)
        wp.penetration = 1000.0
        wp.cycletime = 0
        wp.reloadtime = -10
        wp.accuracy = 0
        wp.spread = 10
    end
    pcall(weaponindex)
end
 --自行在韩服lua网址上查各数值的意思
        --http://cso.dn.nexoncdn.co.kr/vxlman/api/classes/Common.WeaponOption.html#Common.WeaponOption.cycletime