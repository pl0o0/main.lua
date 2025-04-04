local Players = game:GetService("Players") -- playerS
local RunService = game:GetService("RunService") -- RunService - 動いたりするときに発生するイベント"動くサービス"
local UserInputService = game:GetService("UserInputService")-- UserInputService - ユーザーがマウスなどを操作したときの処理をする"ユーザー入力サービス"

local LocalPlayer = Players.LocalPlayer -- LocalPlayer" not players
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() -- Character - Inside of localPlayer - "HumanoidRootPart" is in here also "Humanoid"
local Humanoid = Character:WaitForChild("Humanoid") -- Humanoid - Get Humanoid is from "Character" Change Player Stat From Here
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") -- RootPart - Has CFrame Teleport = Change CFrame, Get Player CFrame From Here And Change 

local flying = false -- For Fly - False =  off
local flySpeed = 100  -- Speed
local maxFlySpeed = 1000 -- Max (min 100, 1000)
local speedIncrement = 0.4 -- in crement - For slider
local originalGravity = workspace.Gravity -- get Workspace Grvity
LocalPlayer.CharacterAdded：Connect(function(newCharacter) --"キャラクター"キャラクター"が追加されたときに接続する引数(newCharacter)でCharacterAddedが呼び出される(好きな文字でも動く):死んでもキャラクターは作り直され新しく追加される
    Character = newCharacter --上にあるlocalplayer.characterAddedなどを引数で呼び出す。
    Humanoid = Character:WaitForChild("Humanoid") --上のcharacterAddedからHumanoidを待つ。
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") --上のCharacterからHumanoidRootPartを取り出す。
end)

local function randomizeValue(value, range) -- local functionは中身randomizeValueを呼び出す、または中身を限定するため、引数は他の文字でも代用可
    return value + (value * (math.random(-range, range) / 100)) -- returnはfunction(関数)が何か処理を行った際に呼び出し元に戻す
end

local function fly() -- 関数(fly)
    while flying do  --ここでさっきfalseにしたflyingをtrueにし、オンオフを切り替える。
        local MoveDirection = Vector3.new() -- Vector3はx,y,zで座標を決める
        local cameraCFrame = workspace.CurrentCamera.CFrame -- CurrentCameraは各プレイヤーの所持す個人のカメラ、CFrameは向き。ここで今向いている位置などを取得する。

        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.W) and cameraCFrame.LookVector or Vector3.new())--向きとキーで動くところを決める
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.S) and cameraCFrame.LookVector or Vector3.new())--向きとキーで動くところを決める
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.A) and cameraCFrame.RightVector or Vector3.new())--向きとキーで動くところを決める
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.D) and cameraCFrame.RightVector or Vector3.new())--向きとキーで動くところを決める
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, 1, 0) or Vector3.new())--向きとキーで動くところを決める
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0, 1, 0) or Vector3.new())--向きとキーで動くところを決める

        if MoveDirection.Magnitude > 0 then -- MoveDirectin = vector3.new().MagnitudeはpropatiesでVector3の中身　"."はParent.Propaties >0は0より大きければ、0の場合移動が無いため処理が行われない。
            flySpeed = math.min(flySpeed + speedIncrement, maxFlySpeed) --flyspeedをここで計算する。
            MoveDirection = MoveDirection.Unit * math.min(randomizeValue(flySpeed, 10), maxFlySpeed)--MoveDirection.UnitのUnitはVectorの方向を単位に変える
            HumanoidRootPart.Velocity = MoveDirection * 0.5 --HumanoidRootPart.Velocityでプレイヤーの移動スピードを変える*0.5
        else
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) --elseはif > 0だった場合移動しない。
        end

        RunService.RenderStepped:Wait() --RenderSteppedでRunServiceをレンダーと同じにさせる。
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed) -- inputbeganでflyを操る(inputbeganは押されたボタンのこと)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then -- ここでinputobeganを設定しFでflyの切り替えgameProcessedはFキーの処理を行う
        flying = not flying -- InputBegan Fの切り替え
        if flying then -- flyingがtrueならば true = on false = off
            workspace.Gravity = 0 --ワールドの重力が0になる。
            fly() --引数flyを実行
        else
            flySpeed = 100 --元に戻す
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)--元に戻す
            workspace.Gravity = originalGravity --元に戻す
        end
    end
end)
