import { TimerState } from '../model/PomodoroState'

@Component
export struct TimerControls {
  @Prop state: TimerState = TimerState.IDLE
  onStart: () => void = () => {}
  onPause: () => void = () => {}
  onReset: () => void = () => {}

  build() {
    Row({ space: 12 }) {
      // 重置按钮
      Button() {
        Text('')
          .fontSize(18)
          .fontColor('#FFFFFF')
      }
      .type(ButtonType.Circle)
      .width(44)
      .height(44)
      .backgroundColor('#33FFFFFF')
      .borderRadius(22)
      .onClick(() => this.onReset())

      // 开始/暂停按钮
      Button() {
        Text(this.isPlaying ? '' : '')
          .fontSize(22)
          .fontColor('#FFFFFF')
      }
      .type(ButtonType.Circle)
      .width(56)
      .height(56)
      .backgroundColor(this.isPlaying ? '#FF6B6B' : '#4ECDC4')
      .borderRadius(28)
      .shadow({
        radius: 12,
        color: this.isPlaying ? '#66FF6B6B' : '#664ECDC4',
        offsetX: 0,
        offsetY: 2
      })
      .onClick(() => {
        if (this.isPlaying) {
          this.onPause()
        } else {
          this.onStart()
        }
      })
    }
    .justifyContent(FlexAlign.Center)
  }

  private get isPlaying(): boolean {
    return this.state === TimerState.WORKING ||
      this.state === TimerState.SHORT_BREAK ||
      this.state === TimerState.LONG_BREAK
  }
}
