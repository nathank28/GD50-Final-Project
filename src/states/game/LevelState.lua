LevelState = Class{__includes = BaseState}

function LevelState:init(stats, close)
    self.levelMenu = Menu {
        x = 45,
        y = 25,
        width = 220,
        height = 140,
        selectVal = false,
        items = stats
    }

    self.close = close
end

function LevelState:update(dt)
    self.levelMenu:update(dt)

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateStack:pop()
        self:close()
    end
end

function LevelState:render()
    self.levelMenu:render()
end