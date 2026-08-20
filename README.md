# xv6 全部 Labs 课程设计（MIT 6.S081 2020）

本项目对应《操作系统课程设计》A 级路线：在 RISC-V 版 xv6 上完成 MIT
6.S081 2020 的全部 11 个实验，并保留每个实验的独立 Git 分支、官方评分脚本、
实验报告和现场演示工具。

项目作者：李胤龙（学号 2453195，79 组，选课课号 42028704，单人完成）。

源码托管地址：<https://github.com/lilong555/xv6-all-labs-2020-course-project>

## 阅读导航

- [完整实验报告](docs/实验报告.md)
- [实验报告 DOCX](output/docx/xv6全实验课程设计报告.docx)
- [实验报告 PDF](output/pdf/xv6全实验课程设计报告.pdf)
- [答辩与现场演示指南](docs/答辩指南.md)
- [官方评分结果](docs/评分结果.md)
- [课程原始要求](24级操作系统课程设计课程说明-王老师嘉定班.pdf)
- [xv6 项目说明](xv6及Labs课程项目（2026）.pdf)

## 实验分支

| 顺序 | 分支 | 实验主题 | 主要内容 |
|---:|---|---|---|
| 1 | `util` | Unix utilities | sleep、pingpong、primes、find、xargs |
| 2 | `syscall` | System calls | trace、sysinfo |
| 3 | `pgtbl` | Page tables | vmprint、每进程内核页表、copyin 优化 |
| 4 | `traps` | Traps | backtrace、周期 alarm |
| 5 | `lazy` | Lazy allocation | sbrk 惰性分配、缺页处理 |
| 6 | `cow` | Copy-on-write | COW fork、物理页引用计数 |
| 7 | `thread` | Multithreading | 用户线程切换、并行哈希表、barrier |
| 8 | `lock` | Locking | 每 CPU 内存分配器、分桶块缓存 |
| 9 | `fs` | File system | 双重间接块、符号链接 |
| 10 | `mmap` | mmap | 文件映射、VMA、回写与解除映射 |
| 11 | `net` | Network driver | E1000 发送与接收 |

`course-project` 是文档和工具入口；实验代码按 MIT 约定保存在同名分支，避免把
不同 Lab 的互斥改动合并成一个无法由官方脚本验证的内核。

## 快速开始

推荐 Ubuntu 22.04 或 24.04。首次安装环境：

```bash
sudo ./scripts/setup-ubuntu.sh
```

运行全部官方评分（不会切换或污染当前工作分支）：

```bash
./scripts/grade-all.sh
```

单独进入某个实验并启动 xv6：

```bash
./scripts/demo-lab.sh cow
```

也可以直接使用 Git：

```bash
git switch syscall
make grade
make qemu
```

退出 QEMU：先按 `Ctrl-a`，再按 `x`。

## 环境基线

- Ubuntu 22.04 LTS：`riscv64-linux-gnu-gcc` 11.4、QEMU 6.2
- Ubuntu 24.04 LTS：`riscv64-linux-gnu-gcc` 13.3、QEMU 8.2
- Python 3

源码包含针对当前 GCC/binutils 的两处构建兼容处理：保留 xv6 的严格警告策略，
仅将 shell 中已知的递归误报降级，并显式导出 `_entry` 内核入口符号。

## 代码来源说明

项目以 MIT xv6/6.S081 2020 实验框架为基础，并参考公开实现历史完成与复核各实验。
提交时应保留本说明、MIT 许可证与 Git 历史。课程答辩应以本仓库的实验报告、代码
差异和现场测试为依据，能够解释关键数据结构、并发约束及错误路径。
