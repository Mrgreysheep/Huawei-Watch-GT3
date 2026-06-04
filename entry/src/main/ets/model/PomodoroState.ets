export enum TimerState {
  IDLE,
  WORKING,
  SHORT_BREAK,
  LONG_BREAK,
  PAUSED
}

export enum TimerMode {
  WORK = 0,
  SHORT_BREAK = 1,
  LONG_BREAK = 2
}

interface TimerConfig {
  WORK_DURATION: number
  SHORT_BREAK_DURATION: number
  LONG_BREAK_DURATION: number
  SESSIONS_BEFORE_LONG_BREAK: number
}

export const TIMER_CONFIG: TimerConfig = {
  WORK_DURATION: 25 * 60,
  SHORT_BREAK_DURATION: 5 * 60,
  LONG_BREAK_DURATION: 15 * 60,
  SESSIONS_BEFORE_LONG_BREAK: 4,
}

export class PomodoroModel {
  state: TimerState = TimerState.IDLE
  mode: TimerMode = TimerMode.WORK
  remainingSeconds: number = TIMER_CONFIG.WORK_DURATION
  totalSeconds: number = TIMER_CONFIG.WORK_DURATION
  completedSessions: number = 0
  currentSession: number = 0

  constructor() {
    this.reset()
  }

  reset(): void {
    this.state = TimerState.IDLE
    this.mode = TimerMode.WORK
    this.remainingSeconds = TIMER_CONFIG.WORK_DURATION
    this.totalSeconds = TIMER_CONFIG.WORK_DURATION
    this.currentSession = 0
  }

  start(): void {
    if (this.state === TimerState.IDLE || this.state === TimerState.PAUSED) {
      this.state = this.mode === TimerMode.WORK
        ? TimerState.WORKING
        : this.mode === TimerMode.SHORT_BREAK
          ? TimerState.SHORT_BREAK
          : TimerState.LONG_BREAK
    }
  }

  pause(): void {
    this.state = TimerState.PAUSED
  }

  tick(): boolean {
    if (this.state === TimerState.WORKING ||
      this.state === TimerState.SHORT_BREAK ||
      this.state === TimerState.LONG_BREAK) {
      this.remainingSeconds--
      if (this.remainingSeconds <= 0) {
        this.onTimerComplete()
        return true
      }
    }
    return false
  }

  private onTimerComplete(): void {
    if (this.state === TimerState.WORKING) {
      this.completedSessions++
      this.currentSession++
      if (this.currentSession % TIMER_CONFIG.SESSIONS_BEFORE_LONG_BREAK === 0) {
        this.switchToMode(TimerMode.LONG_BREAK)
      } else {
        this.switchToMode(TimerMode.SHORT_BREAK)
      }
    } else {
      this.switchToMode(TimerMode.WORK)
    }
  }

  switchToMode(mode: TimerMode): void {
    this.mode = mode
    this.state = TimerState.IDLE
    switch (mode) {
      case TimerMode.WORK:
        this.totalSeconds = TIMER_CONFIG.WORK_DURATION
        this.remainingSeconds = TIMER_CONFIG.WORK_DURATION
        break
      case TimerMode.SHORT_BREAK:
        this.totalSeconds = TIMER_CONFIG.SHORT_BREAK_DURATION
        this.remainingSeconds = TIMER_CONFIG.SHORT_BREAK_DURATION
        break
      case TimerMode.LONG_BREAK:
        this.totalSeconds = TIMER_CONFIG.LONG_BREAK_DURATION
        this.remainingSeconds = TIMER_CONFIG.LONG_BREAK_DURATION
        break
    }
  }

  get progress(): number {
    if (this.totalSeconds === 0) return 0
    return 1 - this.remainingSeconds / this.totalSeconds
  }

  get formattedTime(): string {
    const minutes = Math.floor(this.remainingSeconds / 60)
    const seconds = this.remainingSeconds % 60
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
  }

  get modeLabel(): string {
    switch (this.mode) {
      case TimerMode.WORK: return '专注'
      case TimerMode.SHORT_BREAK: return '短休息'
      case TimerMode.LONG_BREAK: return '长休息'
    }
  }
}
