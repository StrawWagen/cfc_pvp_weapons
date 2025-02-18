include( "shared.lua" )

language.Add( "cfc_shaped_charge" )

function ENT:Initialize()
    local myClass = self:GetClass()
    self.explodeTime = CurTime() + GetConVar( myClass .. "_timer" ):GetInt()
end

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

    local fixAngles = self:GetAngles()
    local fixRotation = Vector( 0, 270, 0 )

    fixAngles:RotateAroundAxis(fixAngles:Right(), fixRotation.x)
    fixAngles:RotateAroundAxis(fixAngles:Up(), fixRotation.y)
    fixAngles:RotateAroundAxis(fixAngles:Forward(), fixRotation.z)

    local TargetPos = self:GetPos() + self:GetUp() * ( 9 * self.modelScale )

    local timeLeft = math.Clamp( self.explodeTime - CurTime(), 0, 999999)

    local minutes, seconds = self:FormatTime( timeLeft )
    self.Text = string.format( "%02d", minutes ) .. ":" .. string.format( "%02d", seconds )

    local xoffs = 45 * self.modelScale
    local yoffs = -30 * self.modelScale

    cam.Start3D2D( TargetPos, fixAngles, 0.10 )
        draw.SimpleText( self.Text, "Trebuchet24", xoffs, yoffs, Color( 165, 0, 0, 255 ), 1, 1 )
    cam.End3D2D()
end

function ENT:FormatTime( seconds )

    local m = seconds % 604800 % 86400 % 3600 / 60
    local s = seconds % 604800 % 86400 % 3600 % 60

    return math.floor( m ), math.floor( s )
end
