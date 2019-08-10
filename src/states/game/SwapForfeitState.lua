SwapForfeitState = Class{__includes = BaseState}

function SwapForfeitState:init()
    self.level = Level()

    self.dialogueOpened = false
end

function SwapForfeitState:update(dt)
    if not self.dialogueOpened and love.keyboard.wasPressed('p') then        
        -- heal player pokemon
        gSounds['heal']:play()
        self.level.player.party.pokemon[1].currentHP = self.level.player.party.pokemon[1].HP
        
        -- show a dialogue for it, allowing us to do so again when closed
        gStateStack:push(DialogueState('Your Pokemon has been healed!',
    
        function()
            self.dialogueOpened = false
        end))
    end

    self.level:update(dt)
end

function SwapForfeitState:render()
    self.level:render()
end