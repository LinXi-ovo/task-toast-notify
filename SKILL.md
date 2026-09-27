---
name: task-toast-notify
description: "任务完成时弹 Windows 桌面 toast 提醒（系统通知气泡）。当用户要求'完成时提醒我''弹个通知''任务跑完通知我'，或长任务（流水线/下载/转码/分析）结束需要主动提醒用户时使用。无需外部依赖（System.Windows.Forms NotifyIcon）。"
---

# task-toast-notify · 任务完成桌面提醒

## 工单
- **背景**：长时间任务（翻唱流水线、批量转码、下载、分析）跑完时，用户不在对话前，需要系统通知气泡把他叫回来。
- **输入**：标题（可选，默认"Task done"）、正文（可选）、展示秒数（可选，默认 6）。
- **输出**：Windows 桌面右下角 toast 气泡通知。
- **规则**：脚本必须用 `powershell.exe -STA`（或 Windows PowerShell 5.1，默认 STA）执行，NotifyIcon 依赖 STA 线程；不得阻塞主任务（异步/后台调用）；无外部模块依赖。
- **验收标准**：调用后桌面弹出系统通知气泡，含标题与正文，数秒后自动消失。

## 调用方式
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "<本skill>\scripts\notify.ps1" -Title "RVC 流水线完成" -Message "莫愁乡 5 轨已生成，可查看 site/" -TimeoutSec 8
```

长任务结束处示例（不阻塞）：
```powershell
Start-Process powershell.exe -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-STA','-File',"<本skill>\scripts\notify.ps1",'-Title','任务完成','-Message','可以去看结果了'
```

## 常见问题
- **气泡不显示**：确认系统通知已开启（设置 → 系统 → 通知）；`powershell.exe` 而非 `pwsh`（PowerShell 7 默认 MTA 会静默失败）；无法弹窗时降级用 `msg.exe %username% "内容"`（老式弹窗，必现）。
- **中文乱码**：脚本文件为 UTF-8 无 BOM 时 PS5.1 按 ANSI 读——保持英文参数最稳，或把脚本存为带 BOM 的 UTF-8 再传中文。
- **多任务**：每次调用独立进程，互不干扰。

## 维护记录
- 2026-09-27：建立（NotifyIcon BalloonTip，无依赖）；未找到现成 toast skill 后自建。
