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

export class PomodoroModel {
  state: TimerState = TimerState.IDLE
  mode: TimerMode = TimerMode.WORK
  remainingSeconds: number = 25 * 60
  totalSeconds: number = 25 * 60

  constructor(mode: TimerMode = TimerMode.WORK) {
    this.mode = mode
    this.totalSeconds = this.getDuration(mode)
    this.remainingSeconds = this.totalSeconds
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
    if (this.state !== TimerState.IDLE) {
      this.state = TimerState.PAUSED
    }
  }

  reset(): void {
    this.state = TimerState.IDLE
    this.remainingSeconds = this.totalSeconds
  }

  tick(): boolean {
    if (this.state === TimerState.WORKING ||
      this.state === TimerState.SHORT_BREAK ||
      this.state === TimerState.LONG_BREAK) {
      this.remainingSeconds--
      if (this.remainingSeconds <= 0) {
        this.remainingSeconds = 0
        this.state = TimerState.IDLE
        return true
      }
    }
    return false
  }

  get isRunning(): boolean {
    return this.state === TimerState.WORKING ||
      this.state === TimerState.SHORT_BREAK ||
      this.state === TimerState.LONG_BREAK
  }

  get progress(): number {
    if (this.totalSeconds === 0) return 0
    return 1 - this.remainingSeconds / this.totalSeconds
  }

  get formattedTime(): string {
    const min = Math.floor(this.remainingSeconds / 60)
    const sec = this.remainingSeconds % 60
    return `${String(min).padStart(2, '0')}:${String(sec).padStart(2, '0')}`
  }

  private getDuration(mode: TimerMode): number {
    switch (mode) {
      case TimerMode.WORK: return 25 * 60
      case TimerMode.SHORT_BREAK: return 5 * 60
      case TimerMode.LONG_BREAK: return 15 * 60
    }
  }
}
