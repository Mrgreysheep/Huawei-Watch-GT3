import { PomodoroModel, TimerState, TimerMode } from '../model/PomodoroState'
import { TimerCircle } from '../components/TimerCircle'
import { TimerControls } from '../components/TimerControls'
import { SessionInfo } from '../components/SessionInfo'
import vibrator from '@ohos.vibrator'

@Entry
@Component
struct Index {
  @State pomodoro: PomodoroModel = new PomodoroModel()
  @State timerInterval: number = -1

  aboutToAppear(): void {
    this.startTimer()
  }

  aboutToDisappear(): void {
    this.clearTimer()
  }

  build() {
    Scroll() {
      Column() {
        // 模式切换按钮
        Row({ space: 8 }) {
          this.ModeButton('专注', TimerMode.WORK)
          this.ModeButton('短休', TimerMode.SHORT_BREAK)
          this.ModeButton('长休', TimerMode.LONG_BREAK)
        }
        .margin({ top: 20 })

        // 主计时器圆环
        TimerCircle({
          progress: this.pomodoro.progress,
          remainingSeconds: this.pomodoro.remainingSeconds,
          state: this.pomodoro.state,
          modeLabel: this.pomodoro.modeLabel
        })
          .margin({ top: 16 })

        // 控制按钮
        TimerControls({
          state: this.pomodoro.state,
          onStart: () => this.handleStart(),
          onPause: () => this.handlePause(),
          onReset: () => this.handleReset()
        })
          .margin({ top: 16 })

        // 会话信息
        SessionInfo({
          completedSessions: this.pomodoro.completedSessions,
          currentSession: this.pomodoro.currentSession
        })
          .margin({ top: 16 })
      }
      .width('100%')
      .padding({
        top: 48,
        bottom: 48,
        left: 24,
        right: 24
      })
      .backgroundColor('#000000')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
  }

  @Builder
  ModeButton(label: string, mode: TimerMode) {
    Button(label)
      .fontSize(12)
      .fontColor(this.pomodoro.mode === mode ? '#FFFFFF' : '#77FFFFFF')
      .backgroundColor(this.pomodoro.mode === mode ? '#FF6B6B' : '#22FFFFFF')
      .borderRadius(12)
      .height(28)
      .onClick(() => {
        this.clearTimer()
        this.pomodoro.switchToMode(mode)
        this.startTimer()
      })
  }

  private startTimer(): void {
    if (this.timerInterval !== -1) return

    this.timerInterval = setInterval(() => {
      const completed = this.pomodoro.tick()
      if (completed) {
        this.vibrateWatch()
      }
    }, 1000)
  }

  private clearTimer(): void {
    if (this.timerInterval !== -1) {
      clearInterval(this.timerInterval)
      this.timerInterval = -1
    }
  }

  private handleStart(): void {
    this.pomodoro.start()
    this.startTimer()
  }

  private handlePause(): void {
    this.pomodoro.pause()
    this.clearTimer()
  }

  private handleReset(): void {
    this.clearTimer()
    this.pomodoro.reset()
  }

  private vibrateWatch(): void {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 500
      }, { id: 0, usage: 'alarm' })
    } catch (e) {
      console.log('vibration not supported')
    }
  }
}
