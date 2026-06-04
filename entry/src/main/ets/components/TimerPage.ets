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
      // 模式名称
      Text(this.getModeName())
        .fontSize(15)
        .fontColor(this.getModeColor())
        .fontWeight(FontWeight.Medium)
        .letterSpacing(2)
        .margin({ top: 8 })

      // 时间显示
      Text(this.pomodoro.formattedTime)
        .fontSize(64)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyOS Sans')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .width('100%')

      // 控制按钮
      Row({ space: 20 }) {
        // 重置
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

        // 开始/暂停
        Button() {
          if (this.pomodoro.isRunning) {
            Row({ space: 4 }) {
              Text('')
                .fontSize(22)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
              Text('')
                .fontSize(22)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
          } else {
            Text('▶')
              .fontSize(20)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
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
      .margin({ bottom: 12 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 48, bottom: 56, left: 28, right: 28 })
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
