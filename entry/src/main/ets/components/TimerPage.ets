import { PomodoroModel, TimerMode } from '../model/PomodoroState'
import vibrator from '@ohos.vibrator'

@Component
export struct TimerPage {
  @State pomodoro: PomodoroModel = new PomodoroModel(TimerMode.WORK)
  @State timerInterval: number = -1

  aboutToDisappear(): void {
    this.clearTimer()
  }

  build() {
    Column() {
      // 顶部标签
      Text(this.getModeName())
        .fontSize(15)
        .fontColor(this.getModeColor())
        .fontWeight(FontWeight.Medium)
        .letterSpacing(2)
        .margin({ top: 8 })

      // 中间时间（占据所有剩余空间，自动垂直居中）
      Text(this.pomodoro.formattedTime)
        .fontSize(64)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyOS Sans')
        .layoutWeight(1)

      // 底部按钮
      Row({ space: 20 }) {
        // 重置按钮
        Button() {
          Text('↻')
            .fontSize(22)
            .fontColor('#8E8E93')
        }
        .type(ButtonType.Circle)
          .width(44)
          .height(44)
          .backgroundColor('#1C1C1E')
          .borderRadius(22)
          .onClick(() => this.handleReset())

        // 播放/暂停按钮
        Button() {
          if (this.pomodoro.isRunning) {
            Row({ space: 5 }) {
              Rect()
                .width(4)
                .height(18)
                .fill('#FFFFFF')
                .borderRadius(2)
              Rect()
                .width(4)
                .height(18)
                .fill('#FFFFFF')
                .borderRadius(2)
            }
            .width(18)
            .height(20)
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
          } else {
            Polygon()
              .width(20)
              .height(20)
              .points([[2, 0], [2, 20], [18, 10]])
              .fill('#FFFFFF')
          }
        }
        .type(ButtonType.Circle)
          .width(56)
          .height(56)
          .backgroundColor(this.pomodoro.isRunning ? '#FF6B6B' : '#30D158')
          .borderRadius(28)
          .onClick(() => this.handleToggle())
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 4 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 48, bottom: 64, left: 28, right: 28 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  private getModeName(): string {
    switch (this.pomodoro.mode) {
      case TimerMode.WORK: return '专注'
      case TimerMode.SHORT_BREAK: return '短休息'
      case TimerMode.LONG_BREAK: return '长休息'
      default: return '专注'
    }
  }

  private getModeColor(): ResourceColor {
    switch (this.pomodoro.mode) {
      case TimerMode.WORK: return '#FF6B6B'
      case TimerMode.SHORT_BREAK: return '#30D158'
      case TimerMode.LONG_BREAK: return '#0A84FF'
      default: return '#FF6B6B'
    }
  }

  private handleToggle(): void {
    if (this.pomodoro.isRunning) {
      this.pomodoro.pause()
      this.clearTimer()
    } else {
      this.pomodoro.start()
      this.startTimer()
    }
  }

  private handleReset(): void {
    this.clearTimer()
    this.pomodoro.reset()
  }

  private startTimer(): void {
    if (this.timerInterval !== -1) return
    this.timerInterval = setInterval(() => {
      const done = this.pomodoro.tick()
      if (done) {
        this.vibrate()
        this.clearTimer()
      }
    }, 1000)
  }

  private clearTimer(): void {
    if (this.timerInterval !== -1) {
      clearInterval(this.timerInterval)
      this.timerInterval = -1
    }
  }

  private vibrate(): void {
    try {
      vibrator.startVibration({ type: 'time', duration: 600 }, { id: 0, usage: 'alarm' })
    } catch (e) {
      console.log('vibration not supported')
    }
  }
}
