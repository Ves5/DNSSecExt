import dns.resolver
# argument parser
import argparse
import pathlib
# progressbar time elapsed
from timeit import default_timer as timer
from datetime import timedelta
# for type hints
from typing import List
# csv handing
import pandas as p

# https://stackoverflow.com/a/34325723
def progressBar(iterable, prefix = '', suffix = '', decimals = 1, length = 100, fill = '█', printEnd = "\r"):
    """
    Call in a loop to create terminal progress bar
    @params:
        iterable    - Required  : iterable object (Iterable)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
        printEnd    - Optional  : end character (e.g. "\\r", "\\r\\n") (Str)
    """
    total = len(iterable)
    start = timer()
    # Progress Bar Printing Function
    def printProgressBar (iteration):
        percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
        filledLength = int(length * iteration // total)
        bar = fill * filledLength + '-' * (length - filledLength)
        print(f'\r{prefix} |{bar}| {percent}% {suffix} | Time elapsed: {timedelta(seconds=timer() - start)}s', end = printEnd)
    # Initial Call
    printProgressBar(0)
    # Update Progress Bar
    for i, item in enumerate(iterable):
        yield item
        printProgressBar(i + 1)
    # Print New Line on Complete
    print()

# test_domains = ['google.com', 'facebook.com', 'cloudflare.com', 'jandaciuk.pl', 'trojmiasto.pl']

def query(domains: List[str], nameservers: List[str]) -> List[float]:
    resolver = dns.resolver.Resolver()
    if(len(nameservers) > 0):
        resolver.nameservers = nameservers
        
    results = []
    for domain in progressBar(domains, prefix='Resolving domains | Progress:', suffix='Complete', length=50):
        res = resolver.resolve(domain, 'A')
        results.append(res.response.time)
    
    return results

def argparser_init() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Test DNS server query time.")
    required = parser.add_argument_group('required arguments')
    required.add_argument('-n', '--nameserver', action='append', default=[], 
                        dest='nameservers', required=True,
                        help='ip address of nameserver used in testing')
    required.add_argument('-i', '--input', '-d', '--data', action='store', default='', dest='input',
                        type=pathlib.Path, required=True,
                        help='path to csv file with domain names')
    parser.add_argument('-o', '--output', action='store', default='./results.csv', 
                        dest='output', type=pathlib.Path, 
                        help='file to write results to specified place\n by default writes to ./results.csv')
    
    return parser



if __name__ == "__main__":
    # parse args
    parser = argparser_init()
    args = parser.parse_args()
    # read CSV file with domains into memory?
    domains = p.read_csv(args.input, header=None)[0].values.tolist()
    print(domains)
    results = p.DataFrame(query(domains, args.nameservers))
    print(results)
    results.to_csv(args.output, header=False, index=False)
    exit(0)