import { TimerPage } from '../components/TimerPage'
import { TimerMode } from '../model/PomodoroState'

@Entry
@Component
struct Index {
  build() {
    Tabs({ barPosition: BarPosition.Hidden }) {
      TabContent() {
        TimerPage({ pomodoro: new PomodoroModel(TimerMode.WORK) })
      }
      .tabBar('')

      TabContent() {
        TimerPage({ pomodoro: new PomodoroModel(TimerMode.SHORT_BREAK) })
      }
      .tabBar('')

      TabContent() {
        TimerPage({ pomodoro: new PomodoroModel(TimerMode.LONG_BREAK) })
      }
      .tabBar('')
    }
    .scrollable(true)
    .barWidth(0)
    .barHeight(0)
    .onChange((index: number) => {})
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}
