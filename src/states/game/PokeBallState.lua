PokeBallState = Class{__includes = BaseState}

function PokeBallState:init(battleState)
    self.battleState = battleState
    self.level = self.battleState.level
    self.opponentPokemon = self.battleState.opponent.party.pokemon[1]
    self.opponentSprite = self.battleState.opponentSprite
    self.pokeBallVal = BattleSprite('masterball', 20, VIRTUAL_HEIGHT - 80)
end

function PokeBallState:enter(params)
    Timer.tween(1, {
        [self.pokeBallVal] = { opacity = 255 }
    }):finish(function()
        self:catch(self.opponentPokemon, function()
            self:fading()
        end)
    end)
end

function PokeBallState:caughtPokemon(pokemon, subVal)
    gStateStack:push(BattleMessageState('Congrats on the Catch!!', function() end), false)
    Timer.after(0.3, function()
        gStateStack:pop()
    end)

    Timer.after(0.3, function()
        gStateStack:pop()
        subVal()
    end)
end

function PokeBallState:freedPokemon(pokemon, subVal)
        gStateStack:pop()
        gStateStack:push(BattleMessageState('Weaken the Enemy More!!', function() end), false)

    Timer.after(0.5, function()
        gStateStack:pop()
        gStateStack:push(BattleMenuState(self.battleState))
    end)
end

function PokeBallState:catch(pokemon, subVal)

    gStateStack:push(BattleMessageState('Im gonna catch you!',
    function() end), false)

    Timer.tween(1, {
        [self.pokeBallVal] = { x = self.opponentSprite.x - 
        (gTextures[self.opponentSprite.texture]:getHeight()/2), 
            y = self.opponentSprite.y - 
            (gTextures[self.opponentSprite.texture]:getHeight()/2)},

    })
        :finish(
            function()
                Timer.tween(0.3, {
                [self.pokeBallVal] = { x = self.opponentSprite.x, y = self.opponentSprite.y },
                })
                :finish(
                    function()                                        
                        local pokePercentage = math.random(5)
                        local caughtVal = math.random(5)

                        gStateStack:pop()
                                                                
                        if pokePercentage <= caughtVal then
                            self.opponentSprite.opacity = 0
                            self.battleState.player.masterball = self.battleState.player.masterball - 1
                            self:caughtPokemon(pokemon, subVal)
                        else
                            self.opponentSprite.opacity = 0
                            self.battleState.player.masterball = self.battleState.player.masterball - 1
                            self:freedPokemon(pokemon, subVal)
                        end
                    end)
            end)
end

function PokeBallState:fading()
    gStateStack:push(FadeInState({
        r = 255, g = 255, b = 255
    }, 1,
    function()
        gSounds['field-music']:play()
        gStateStack:pop()
        gStateStack:push(FadeOutState({
            r = 255, g = 255, b = 255
        }, 1, function() end))
    end))
end

function PokeBallState:render()
    self.pokeBallVal:render()
end
