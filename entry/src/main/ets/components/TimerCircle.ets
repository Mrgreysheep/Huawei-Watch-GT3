import { TimerState } from '../model/PomodoroState'

@Component
export struct TimerCircle {
  @Prop progress: number = 0
  @Prop remainingSeconds: number = 1500
  @Prop state: TimerState = TimerState.IDLE
  @Prop modeLabel: string = '专注'

  private circleWidth: number = 200

  build() {
    Stack() {
      // 进度弧线 - 外圈
      Progress({
        value: this.progress * 100,
        total: 100,
        type: ProgressType.Ring
      })
        .width(this.circleWidth)
        .height(this.circleWidth)
        .style({
          strokeWidth: 8
        })
        .color(this.getModeColor())

      // 中心内容
      Column() {
        // 模式标签
        Text(this.modeLabel)
          .fontSize(14)
          .fontColor('#AAFFFFFF')
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 4 })

        // 时间显示
        Text(this.formattedTime)
          .fontSize(42)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .fontFamily('HarmonyOS Sans')

        // 状态指示
        Row() {
          Circle({ width: 6, height: 6 })
            .fill(this.state === TimerState.IDLE ? '#55FFFFFF' : this.getModeColor())

          Text(this.getStateLabel())
            .fontSize(10)
            .fontColor('#77FFFFFF')
            .margin({ left: 4 })
        }
        .margin({ top: 8 })
      }
      .justifyContent(FlexAlign.Center)
    }
    .width(this.circleWidth)
    .height(this.circleWidth)
  }

  private get formattedTime(): string {
    const minutes = Math.floor(this.remainingSeconds / 60)
    const seconds = this.remainingSeconds % 60
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
  }

  private getModeColor(): ResourceColor {
    switch (this.state) {
      case TimerState.WORKING: return '#FF6B6B'
      case TimerState.SHORT_BREAK: return '#4ECDC4'
      case TimerState.LONG_BREAK: return '#45B7D1'
      default: return '#FF6B6B'
    }
  }

  private getStateLabel(): string {
    switch (this.state) {
      case TimerState.IDLE: return '准备开始'
      case TimerState.WORKING: return '专注中'
      case TimerState.SHORT_BREAK: return '休息中'
      case TimerState.LONG_BREAK: return '长休息'
      case TimerState.PAUSED: return '已暂停'
    }
  }
}
