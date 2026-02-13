import Link from 'next/link';
import { brand } from '@/lib/brand';

interface BrandLinkProps {
  locale?: 'fa' | 'en';
  className?: string;
}

export default function BrandLink({ locale = 'en', className }: BrandLinkProps) {
  const text = locale === 'fa' ? brand.requestLabelFa : brand.requestLabelEn;

  return (
    <Link href={brand.engineeringRequestUrl} target="_blank" rel="noopener noreferrer" className={className}>
      {text}
    </Link>
  );
}

