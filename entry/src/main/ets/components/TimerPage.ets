import { PomodoroModel, TimerMode, TimerState } from '../model/PomodoroState'
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
      // 上半部：标签 + 进度环
      Column({ space: 20 }) {
        // 模式名称
        Text(this.getModeName())
          .fontSize(16)
          .fontColor(this.getModeColor())
          .fontWeight(FontWeight.Medium)
          .letterSpacing(2)

        // 进度环 + 时间
        Stack() {
          Progress({ value: 100, total: 100, type: ProgressType.Ring })
            .width(190)
            .height(190)
            .style({ strokeWidth: 8 })
            .color('#1C1C1E')

          Progress({ value: this.pomodoro.progress * 100, total: 100, type: ProgressType.Ring })
            .width(190)
            .height(190)
            .style({ strokeWidth: 8 })
            .color(this.getModeColor())

          Column({ space: 4 }) {
            Text(this.pomodoro.formattedTime)
              .fontSize(52)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
              .fontFamily('HarmonyOS Sans')

            Text(this.getStateLabel())
              .fontSize(13)
              .fontColor('#8E8E93')
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width(190)
        .height(190)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)

      // 底部控制栏
      Row({ space: 24 }) {
        // 重置
        Button() {
          Text('')
            .fontSize(18)
            .fontColor('#636366')
        }
        .type(ButtonType.Circle)
          .width(48)
          .height(48)
          .backgroundColor('#1C1C1E')
          .borderRadius(24)
          .onClick(() => this.handleReset())

        // 开始/暂停
        Button() {
          Text(this.pomodoro.isRunning ? '' : '')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Circle)
          .width(64)
          .height(64)
          .backgroundColor(this.pomodoro.isRunning ? '#FF6B6B' : '#30D158')
          .borderRadius(32)
          .onClick(() => this.handleToggle())
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .padding({ bottom: 24 })
    }
    .width('100%')
    .height('100%')
  }

  private getModeName(): string {
    switch (this.pomodoro.mode) {
      case TimerMode.WORK: return '专注'
      case TimerMode.SHORT_BREAK: return '短休息'
      case TimerMode.LONG_BREAK: return '长休息'
      default: return '专注'
    }
  }

  private getStateLabel(): string {
    switch (this.pomodoro.state) {
      case TimerState.IDLE: return '准备开始'
      case TimerState.WORKING: return '专注中'
      case TimerState.SHORT_BREAK: return '休息中'
      case TimerState.LONG_BREAK: return '休息中'
      case TimerState.PAUSED: return '已暂停'
      default: return ''
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
