import { TimerState } from '../model/PomodoroState'

@Component
export struct TimerControls {
  @Prop state: TimerState = TimerState.IDLE
  onStart: () => void = () => {}
  onPause: () => void = () => {}
  onReset: () => void = () => {}

  build() {
    Row({ space: 20 }) {
      // 重置
      Button() {
        Text('')
          .fontSize(20)
          .fontColor('#8E8E93')
      }
      .type(ButtonType.Circle)
      .width(44)
      .height(44)
      .backgroundColor('#2C2C2E')
      .borderRadius(22)
      .onClick(() => this.onReset())

      // 播放/暂停
      Button() {
        Text(this.isPlaying ? '' : '')
          .fontSize(24)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
      }
      .type(ButtonType.Circle)
      .width(56)
      .height(56)
      .backgroundColor(this.isPlaying ? '#FF6B6B' : '#30D158')
      .borderRadius(28)
      .onClick(() => {
        if (this.isPlaying) {
          this.onPause()
        } else {
          this.onStart()
        }
      })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  private get isPlaying(): boolean {
    return this.state === TimerState.WORKING ||
      this.state === TimerState.SHORT_BREAK ||
      this.state === TimerState.LONG_BREAK
  }
}
