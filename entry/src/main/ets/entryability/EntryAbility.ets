import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log('PomodoroTimer onCreate')
  }

  onDestroy(): void {
    console.log('PomodoroTimer onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        console.error('Failed to load content:', err)
        return
      }
      console.log('Content loaded successfully')
    })
  }

  onWindowStageDestroy(): void {
    console.log('WindowStage destroyed')
  }

  onForeground(): void {
    console.log('App foreground')
  }

  onBackground(): void {
    console.log('App background')
  }
}
