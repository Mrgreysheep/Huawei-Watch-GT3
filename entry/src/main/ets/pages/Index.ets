import { PomodoroModel, TimerMode, TimerState } from '../model/PomodoroState'
import { TimerCircle } from '../components/TimerCircle'
import { TimerControls } from '../components/TimerControls'
import { SessionInfo } from '../components/SessionInfo'
import vibrator from '@ohos.vibrator'

@Entry
@Component
struct Index {
  @State pomodoro: PomodoroModel = new PomodoroModel()
  private timerInterval: number = -1

  aboutToAppear(): void {
    this.startTimer()
  }

  aboutToDisappear(): void {
    this.clearTimer()
  }

  build() {
    Scroll() {
      Column() {
        // 模式切换
        Row({ space: 6 }) {
          this.ModeTab('专注', TimerMode.WORK)
          this.ModeTab('短休', TimerMode.SHORT_BREAK)
          this.ModeTab('长休', TimerMode.LONG_BREAK)
        }

        // 进度圆环 + 时间
        TimerCircle({
          progress: this.pomodoro.progress,
          remainingSeconds: this.pomodoro.remainingSeconds,
          state: this.pomodoro.state,
          modeLabel: this.getModeLabel()
        })

        // 控制按钮
        TimerControls({
          state: this.pomodoro.state,
          onStart: () => this.handleStart(),
          onPause: () => this.handlePause(),
          onReset: () => this.handleReset()
        })

        // 会话信息
        SessionInfo({
          completedSessions: this.pomodoro.completedSessions,
          currentSession: this.pomodoro.currentSession
        })
      }
      .width('100%')
      .padding({ top: 50, bottom: 50, left: 28, right: 28 })
      .backgroundColor('#000000')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
  }

  @Builder
  ModeTab(label: string, mode: TimerMode) {
    Text(label)
      .fontSize(13)
      .fontColor(this.pomodoro.mode === mode ? '#FF6B6B' : '#8E8E93')
      .fontWeight(this.pomodoro.mode === mode ? FontWeight.Medium : FontWeight.Normal)
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .backgroundColor(this.pomodoro.mode === mode ? '#2C1A1A' : 'transparent')
      .borderRadius(16)
      .onClick(() => {
        this.clearTimer()
        this.pomodoro.switchToMode(mode)
        this.startTimer()
      })
  }

  private getModeLabel(): string {
    switch (this.pomodoro.mode) {
      case TimerMode.WORK: return '专注'
      case TimerMode.SHORT_BREAK: return '短休息'
      case TimerMode.LONG_BREAK: return '长休息'
      default: return '专注'
    }
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
      vibrator.startVibration({ type: 'time', duration: 500 }, { id: 0, usage: 'alarm' })
    } catch (e) {
      console.log('vibration not supported')
    }
  }
}
