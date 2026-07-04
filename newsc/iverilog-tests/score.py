#!/usr/bin/env python3
import json
import re
import sys
import os
import subprocess

def parse_simulation_output(output):
    registers = {}
    reg_pattern = re.compile(r'\[REG\]\s*x(\d+)=([0-9a-fA-F]{8})')
    
    for line in output.split('\n'):
        reg_match = reg_pattern.search(line)
        if reg_match:
            registers[int(reg_match.group(1))] = int(reg_match.group(2), 16)
    
    return registers

def load_expected_results(json_path):
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def resolve_same_as(expected_results, test_key):
    while 'same_as' in expected_results[test_key]:
        test_key = expected_results[test_key]['same_as']
    return expected_results[test_key]

def run_single_test(test_name, expected_results, cpu_type):
    dat_path = f'tests/{cpu_type}/{test_name}.dat'
    test_key = f'{cpu_type}/{test_name}.dat'
    
    if not os.path.exists(dat_path):
        return {'name': test_name, 'passed': 0, 'total': 0, 'error': '文件不存在'}
    
    if test_key not in expected_results:
        return {'name': test_name, 'passed': 0, 'total': 0, 'error': '无期望结果'}
    
    out_file = f'{cpu_type}_final.out'
    if not os.path.exists(out_file):
        return {'name': test_name, 'passed': 0, 'total': 0, 'error': f'{out_file}不存在'}
    
    expected = resolve_same_as(expected_results, test_key)
    cmd = f'vvp {out_file} +IMEM={dat_path} +CYCLES=100'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    regs = parse_simulation_output(result.stdout)
    
    expected_regs = expected.get('regs', {})
    passed = 0
    total = len(expected_regs)
    details = []
    
    for reg_name, expected_hex in expected_regs.items():
        reg_num = int(reg_name.replace('x', ''))
        expected_val = int(expected_hex, 16)
        actual_val = regs.get(reg_num, 0)
        
        details.append({
            'status': 'PASS' if actual_val == expected_val else 'FAIL',
            'reg': reg_name,
            'expected': expected_val,
            'actual': actual_val
        })
        if actual_val == expected_val:
            passed += 1
    
    return {
        'name': test_name, 'passed': passed, 'total': total,
        'details': details, 'covers': expected.get('covers', []), 'error': None
    }

def run_cpu_tests(cpu_type, expected_results):
    test_files = sorted([f for f in os.listdir(f'tests/{cpu_type}') if f.endswith('.dat')])
    test_names = [f.replace('.dat', '') for f in test_files]
    
    print(f"\n{'='*60}")
    print(f"测试 {cpu_type.upper()} CPU")
    print(f"{'='*60}")
    
    results = []
    total_passed = 0
    total_checks = 0
    
    for test_name in test_names:
        result = run_single_test(test_name, expected_results, cpu_type)
        results.append(result)
        
        if result['error']:
            print(f"❌ {test_name}: {result['error']}")
            continue
        
        total_passed += result['passed']
        total_checks += result['total']
        status = '✓' if result['passed'] == result['total'] else '✗'
        print(f"{status} {test_name}: {result['passed']}/{result['total']}")
    
    return {'results': results, 'passed': total_passed, 'total': total_checks}

def main():
    if len(sys.argv) != 2 or sys.argv[1] != 'all':
        print("用法:")
        print("  python score.py all    # 同时测试 sc 和 pl，输出综合总分")
        print("  python score.py sc     # 仅测试单周期 CPU")
        print("  python score.py pl     # 仅测试流水线 CPU")
        sys.exit(1)
    
    expected_results = load_expected_results('tests/expected_results.json')
    
    sc_result = run_cpu_tests('sc', expected_results)
    pl_result = run_cpu_tests('pl', expected_results)
    # 计算总检查项
    total_passed = sc_result['passed'] + pl_result['passed']
    total_checks = sc_result['total'] + pl_result['total']
    
    # 输出综合报告
    print(f"\n{'='*70}")
    print("综合评分报告")
    print(f"{'='*70}")
    print(f"单周期 CPU: {sc_result['passed']}/{sc_result['total']}")
    print(f"流水线 CPU: {pl_result['passed']}/{pl_result['total']}")
    print(f"{'='*70}")
    print(f"总得分: {total_passed}/{total_checks}")
    print(f"{'='*70}")

if __name__ == '__main__':
    main()