import { TimerState } from '../model/PomodoroState'

@Component
export struct TimerCircle {
  @Prop progress: number = 0
  @Prop remainingSeconds: number = 1500
  @Prop state: TimerState = TimerState.IDLE
  @Prop modeLabel: string = '专注'

  private readonly circleSize: number = 220
  private readonly strokeWidth: number = 10
  private readonly bgStrokeWidth: number = 10

  build() {
    Stack() {
      // 外层底环
      Progress({ value: 100, total: 100, type: ProgressType.Ring })
        .width(this.circleSize)
        .height(this.circleSize)
        .style({ strokeWidth: this.bgStrokeWidth })
        .color('#1C1C1E')

      // 进度弧
      Progress({ value: this.progress * 100, total: 100, type: ProgressType.Ring })
        .width(this.circleSize)
        .height(this.circleSize)
        .style({ strokeWidth: this.strokeWidth })
        .color(this.getActiveColor())

      // 中心数字
      Column() {
        Text(this.getFormattedTime())
          .fontSize(48)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .fontFamily('HarmonyOS Sans')

        Text(this.stateLabel)
          .fontSize(13)
          .fontColor('#8E8E93')
          .fontWeight(FontWeight.Normal)
          .margin({ top: 4 })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width(this.circleSize)
    .height(this.circleSize)
  }

  private getFormattedTime(): string {
    const min = Math.floor(this.remainingSeconds / 60)
    const sec = this.remainingSeconds % 60
    return `${String(min).padStart(2, '0')}:${String(sec).padStart(2, '0')}`
  }

  private get stateLabel(): string {
    switch (this.state) {
      case TimerState.IDLE: return this.modeLabel
      case TimerState.WORKING: return '专注中'
      case TimerState.SHORT_BREAK: return '短休息'
      case TimerState.LONG_BREAK: return '长休息'
      case TimerState.PAUSED: return '已暂停'
      default: return ''
    }
  }

  private getActiveColor(): ResourceColor {
    switch (this.state) {
      case TimerState.WORKING: return '#FF6B6B'
      case TimerState.SHORT_BREAK: return '#4ECDC4'
      case TimerState.LONG_BREAK: return '#45B7D1'
      default: return '#FF6B6B'
    }
  }
}
