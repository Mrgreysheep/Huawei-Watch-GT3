@Component
export struct SessionInfo {
  @Prop completedSessions: number = 0
  @Prop currentSession: number = 0
  private maxDots: number = 4

  build() {
    Column({ space: 8 }) {
      // 会话标题
      Text('今日专注')
        .fontSize(12)
        .fontColor('#77FFFFFF')

      // 会话进度点
      Row({ space: 6 }) {
        ForEach(this.getSessionDots(), (filled: boolean, index: number) => {
          Circle({ width: 8, height: 8 })
            .fill(filled ? '#FF6B6B' : '#33FFFFFF')
            .border({
              width: 1,
              color: filled ? '#FF6B6B' : '#55FFFFFF'
            })
        })
      }
      .justifyContent(FlexAlign.Center)

      // 完成计数
      Text(`${this.completedSessions} 个番茄已完成`)
        .fontSize(11)
        .fontColor('#55FFFFFF')
    }
    .alignItems(HorizontalAlign.Center)
  }

  private getSessionDots(): boolean[] {
    const dots: boolean[] = []
    for (let i = 0; i < this.maxDots; i++) {
      dots.push(i < (this.currentSession % this.maxDots))
    }
    return dots
  }
}
